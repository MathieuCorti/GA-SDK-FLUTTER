#!/usr/bin/env python3
"""Reject tracked drift, allowing only the proven local-pod JSON checksum variant."""
import hashlib
import json
import re
import subprocess
import sys
from pathlib import Path

LOCK = 'example/ios/Podfile.lock'
CHECKSUM = re.compile(r'(?m)^  gameanalytics_sdk: ([0-9a-f]{40})$')


def serialization_hashes(spec):
    # CocoaPods hashes pretty-printed JSON, not its semantic content.
    # https://github.com/CocoaPods/CocoaPods/issues/12807
    current = json.dumps(spec, indent=2, ensure_ascii=False) + '\n'
    legacy = re.sub(
        r'(?m)^(\s+)(.*): \[\]',
        lambda match: match[1] + match[2] + ': [\n\n' + match[1] + ']',
        current,
    )
    return {hashlib.sha1(text.encode()).hexdigest() for text in (current, legacy)}


def validate_local_checksum_change(before, after, installed, declared):
    if installed != declared or installed.get('name') != 'gameanalytics_sdk':
        raise ValueError('Installed local podspec differs from the declared plugin spec.')
    old_hashes, new_hashes = CHECKSUM.findall(before), CHECKSUM.findall(after)
    if len(old_hashes) != 1 or len(new_hashes) != 1:
        raise ValueError('Expected exactly one local plugin checksum in each lockfile.')
    if CHECKSUM.sub('  gameanalytics_sdk: LOCAL_CHECKSUM', before) != CHECKSUM.sub(
            '  gameanalytics_sdk: LOCAL_CHECKSUM', after):
        raise ValueError('Pod versions, external checksums or other lockfile content changed.')
    permitted = serialization_hashes(installed)
    if not set(old_hashes + new_hashes).issubset(permitted):
        raise ValueError('Checksum change is not one of the two known JSON serializations.')


def main():
    root = Path(__file__).resolve().parent.parent
    def git(*args):
        return subprocess.check_output(['git', '-C', str(root), *args], text=True)
    changed = [name for name in git('diff', '--name-only', '-z', 'HEAD', '--').split('\0') if name]
    if not changed:
        print('Tracked checkout is unchanged.')
        return
    if changed != [LOCK]:
        raise ValueError('Unexpected tracked changes: ' + ', '.join(changed))
    installed = json.loads((root / 'example/ios/Pods/Local Podspecs/gameanalytics_sdk.podspec.json').read_text())
    declared = json.loads(subprocess.check_output(
        ['pod', 'ipc', 'spec', str(root / 'ios/gameanalytics_sdk.podspec')], text=True))
    validate_local_checksum_change(
        git('show', 'HEAD:' + LOCK), (root / LOCK).read_text(), installed, declared)
    print('Only known JSON whitespace changed the local pod checksum; all contracts are unchanged.')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        print('Checkout verification failed: ' + str(error), file=sys.stderr)
        sys.exit(1)
