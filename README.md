# GA-SDK-FLUTTER
GameAnalytics SDK for Flutter.

Documentation is located [here](https://gameanalytics.com/docs/s/article/Flutter-SDK-Setup).

If you have any issues or feedback regarding the SDK, please contact our friendly support team [here](https://gameanalytics.com/contact).

> :information_source:
>
> The Flutter SDK include support for **iOS**, **Android** and **Web** platforms

[Changelog](CHANGELOG.md)

## Repository development

Development uses the Flutter version pinned in `.fvmrc`; the package still
supports Dart >=2.12 <4 and Flutter >=2.0. Read the repository's `AGENTS.md` for the
project-local engineering policy and focused validation commands. Start with
`fvm flutter pub get --no-example` and `bash tool/validate.sh`; use `--ci` when
verifying the existing channel-contract suite.

The CI keeps analysis, Android, unsigned iOS, web and archive checks separate.
Only affected surfaces build; documentation changes run local policy checks.
The example's build tooling is a development harness, not a change to the
plugin's consumer requirements. No example build launches analytics or publishes
a package. The legacy JavaScript bridge builds to JavaScript, not WebAssembly.

CocoaPods can serialize an empty dependency array differently across JSON gem
versions ([upstream issue](https://github.com/CocoaPods/CocoaPods/issues/12807)).
The CI checkout check permits only those two reproduced checksums of the same
local podspec, verifies the installed spec matches its source, and still rejects
all dependency, version, external-checksum or other tracked-file changes.
