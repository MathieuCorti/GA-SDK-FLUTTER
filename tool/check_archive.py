#!/usr/bin/env python3
"""Check the actual pub dry-run archive without publishing anything."""
import re
import sys
from pathlib import Path

root = Path(__file__).resolve().parent.parent
text = Path(sys.argv[1]).read_text()
paths = []
listing = False
for line in text.splitlines():
    if 'Creating .tar.gz stream containing:' in line:
        listing = True
        continue
    if listing and line.startswith('MSG :'):
        break
    if listing and line.startswith('    | '):
        path = line[6:]
        prefix = str(root) + '/'
        if path.startswith(prefix):
            path = path[len(prefix):]
        if path != '.':
            paths.append(path)
if not paths:
    raise SystemExit('Missing archive listing in verbose pub dry-run log.')
required = {
    'LICENSE', 'README.md', 'pubspec.yaml', 'analysis_options.yaml',
    'lib/gameanalytics.dart', 'lib/web/gameanalytics_web.dart',
    'android/src/main/java/com/gameanalytics/sdk/flutter/GameAnalyticsPlugin.java',
    'ios/Classes/GameAnalyticsPlugin.m', 'ios/gameanalytics_sdk.podspec',
}
missing = required.difference(paths)
forbidden = re.compile(
    r'(^|/)(\.agents|\.gtm|\.github|\.fvm|\.dart_tool|tool|build|Pods|'
    r'\.symlinks|\.gradle|\.kotlin|__pycache__)(/|$)|'
    r'(^|/)(AGENTS\.md|CLAUDE\.md|\.fvmrc|pubspec\.lock|local\.properties|'
    r'key\.properties|gradle-wrapper\.jar|gradlew|gradlew\.bat)$|'
    r'\.(jks|keystore|p12|pem)$|^/'
)
bad = [path for path in paths if forbidden.search(path)]
if missing or bad:
    raise SystemExit('Archive contract failed: missing=' + str(sorted(missing)) +
                     ', forbidden=' + str(bad))
print('Archive contains the public plugin and excludes repository-only tooling.')
