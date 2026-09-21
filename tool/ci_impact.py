#!/usr/bin/env python3
"""Select affected work while preserving every CI status."""
import argparse
import subprocess

ALL_GATES = {'analysis', 'android', 'ios', 'web', 'package'}


def gates(files):
    if files is None:
        return ALL_GATES.copy()
    selected = set()
    for path in files:
        if path.lower().endswith('.md'):
            continue
        if path in ('.github/workflows/quality.yml', 'tool/ci_impact.py',
                    '.fvmrc', 'pubspec.yaml', 'analysis_options.yaml'):
            return ALL_GATES.copy()
        if path == '.pubignore' or path == 'tool/check_archive.py':
            selected.add('package')
        if path == 'tool/validate.sh' or path.startswith('test/'):
            selected.add('analysis')
        if path == 'tool/build_example.sh' or path.startswith('example/lib/') or path == 'example/pubspec.yaml':
            selected.update(ALL_GATES)
        elif path.startswith('lib/web/'):
            selected.update(('analysis', 'web', 'package'))
        elif path.startswith('lib/'):
            selected.update(ALL_GATES)
        for platform in ('android', 'ios', 'web'):
            if path.startswith(platform + '/'):
                selected.update(('analysis', platform, 'package'))
            if path.startswith('example/' + platform + '/'):
                selected.update((platform, 'package'))
    return selected


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--gate', required=True, choices=sorted(ALL_GATES))
    parser.add_argument('--base')
    parser.add_argument('--files', nargs='*')
    args = parser.parse_args()
    files = args.files
    if files is None and args.base and set(args.base) != {'0'}:
        result = subprocess.run(
            ['git', 'diff', '--name-only', '-z', args.base + '..HEAD', '--'],
            check=True, capture_output=True, text=True,
        )
        files = [path for path in result.stdout.split('\0') if path]
    print('enabled=' + str(args.gate in gates(files)).lower())


if __name__ == '__main__':
    main()
