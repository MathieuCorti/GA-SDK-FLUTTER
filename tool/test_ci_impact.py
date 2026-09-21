"""Regression checks for the small CI routing contract."""
import unittest
from ci_impact import ALL_GATES, gates


class ImpactTests(unittest.TestCase):
    def test_manual_and_ci_changes_run_all_gates(self):
        self.assertEqual(ALL_GATES, gates(None))
        self.assertEqual(ALL_GATES, gates(['.github/workflows/quality.yml']))

    def test_docs_and_skills_need_no_sdk(self):
        self.assertEqual(set(), gates([
            'README.md', 'example/README.md', '.gtm/quality.json',
            '.agents/skills/flutter-project/SKILL.md',
        ]))

    def test_dart_api_keeps_every_platform(self):
        self.assertEqual(ALL_GATES, gates(['lib/gameanalytics.dart']))

    def test_native_and_web_changes_stay_scoped(self):
        for platform in ('android', 'ios'):
            self.assertEqual({'analysis', platform, 'package'}, gates([
                platform + '/implementation',
            ]))
        self.assertEqual({'analysis', 'web', 'package'}, gates([
            'lib/web/gameanalytics_web.dart',
        ]))

    def test_example_platform_and_archive_changes_stay_scoped(self):
        self.assertEqual({'android', 'package'}, gates(['example/android/build.gradle']))
        self.assertEqual({'package'}, gates(['.pubignore']))
        self.assertEqual({'analysis'}, gates(['test/gameanalytics_test.dart']))


if __name__ == '__main__':
    unittest.main()
