#!/usr/bin/env bash
# Build-only verification: never launch the analytics-enabled example.
set -euo pipefail
repository_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repository_root/example"
flutter_command=(flutter)
if command -v fvm >/dev/null 2>&1; then flutter_command=(fvm flutter); fi
"${flutter_command[@]}" pub get
"${flutter_command[@]}" analyze --no-pub --fatal-infos --fatal-warnings lib
case "${1:-}" in
  android) "${flutter_command[@]}" build apk --debug --no-pub ;;
  ios)
    "${flutter_command[@]}" build ios --config-only --debug --no-codesign --no-pub
    cd ios
    pod install
    # This build-only override keeps the development harness compatible with
    # Xcode 27. It does not change the plugin's declared iOS 9 consumer minimum.
    xcodebuild -workspace Runner.xcworkspace -scheme Runner \
      -configuration Debug -destination 'generic/platform=iOS' \
      -derivedDataPath ../build/ios/unsigned \
      CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO \
      IPHONEOS_DEPLOYMENT_TARGET=15.0 build
    ;;
  web) "${flutter_command[@]}" build web --no-pub ;;
  *) printf 'Usage: bash tool/build_example.sh <android|ios|web>\n' >&2; exit 2 ;;
esac
