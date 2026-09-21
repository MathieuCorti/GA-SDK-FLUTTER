# GameAnalytics Flutter plugin engineering

Follow `.gtm/engineering_policy.md` and the project-owned
`.agents/skills/flutter-project/SKILL.md`, especially its library/plugin reference.

- Preserve the public Dart API, channel name, argument keys/types, serialized
  payloads, return values, errors, and exactly-once native replies.
- Keep public requirements at Dart >=2.12 <4 and Flutter >=2.0. Keep GameAnalytics
  iOS 5.0.0, Android 7.0.0, and JavaScript 4.2.1 unless an SDK upgrade is explicitly
  requested. `.fvmrc` pins development only, not consumer minimums.
- Keep lightweight self-contained analysis. Do not add application layers,
  Saropa, state managers, GTM runtime dependencies, or golden comparisons.
- Set up dependencies with `fvm flutter pub get --no-example`; use
  `bash tool/validate.sh` for policy and package analysis, append relevant test
  paths for behavior changes, or `--ci` for the existing contract suite.
- The example is a development harness. Resolve its dependencies separately
  (`cd example && fvm flutter pub get`) and analyze it after example changes.
  Compile affected Android, iOS, or web surfaces with
  `bash tool/build_example.sh <android|ios|web>`. Builds do not publish, sign a
  distribution, or launch the analytics-enabled example.
  The iOS verification command overrides deployment to iOS 15 only for that
  unsigned build (Xcode 27 compatibility); the podspec's iOS 9 floor is unchanged.
- CI has stable quality/status checks; docs changes need policy checks only.
  Native/example builds are selected by the affected platform. Preserve useful
  payload and native-reply coverage; no tests-per-class or coverage quota.
- Keep technical changes in English. Historical notes are context, not active
  requirements. Repository instructions, skills and tools stay out of archives.
- Do not release, bump versions, or import unrelated product commits as part of
  maintenance setup.
