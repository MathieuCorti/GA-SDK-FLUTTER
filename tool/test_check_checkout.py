"""Reject meaningful dependency drift while recognizing CocoaPods JSON formatting."""
import copy
import unittest
from check_checkout import serialization_hashes, validate_local_checksum_change


class CheckoutTests(unittest.TestCase):
    def setUp(self):
        self.spec = {
            'name': 'gameanalytics_sdk', 'version': '1.3.1',
            'dependencies': {'Flutter': [], 'GA-SDK-IOS': ['5.0.0']},
            'platforms': {'ios': '9.0'},
        }
        first, second = sorted(serialization_hashes(self.spec))
        self.before = (
            'PODS:\n  - gameanalytics_sdk (1.3.1)\nSPEC CHECKSUMS:\n'
            '  GA-SDK-IOS: ' + '1' * 40 + '\n'
            '  gameanalytics_sdk: ' + first + '\nCOCOAPODS: 1.17.0\n')
        self.after = self.before.replace(first, second)

    def test_known_formatting_only_is_accepted(self):
        validate_local_checksum_change(self.before, self.after, self.spec, self.spec)

    def test_external_hash_and_lock_metadata_drift_are_rejected(self):
        for changed in (self.after.replace('1' * 40, '2' * 40),
                        self.after.replace('COCOAPODS: 1.17.0', 'COCOAPODS: 1.18.0'),
                        self.after.replace('gameanalytics_sdk (1.3.1)', 'gameanalytics_sdk (2.0.0)')):
            with self.subTest(changed=changed), self.assertRaises(ValueError):
                validate_local_checksum_change(self.before, changed, self.spec, self.spec)

    def test_changed_version_or_native_dependency_is_not_formatting(self):
        for key, value in (('version', '2.0.0'), ('dependencies', {'GA-SDK-IOS': ['6.0.0']})):
            changed = copy.deepcopy(self.spec)
            changed[key] = value
            with self.subTest(key=key), self.assertRaises(ValueError):
                validate_local_checksum_change(self.before, self.after, changed, changed)

    def test_installed_spec_must_equal_source_spec(self):
        changed = copy.deepcopy(self.spec)
        changed['platforms']['ios'] = '15.0'
        with self.assertRaises(ValueError):
            validate_local_checksum_change(self.before, self.after, changed, self.spec)

    def test_unknown_checksum_is_rejected(self):
        changed = self.after.replace(sorted(serialization_hashes(self.spec))[1], '0' * 40)
        with self.assertRaises(ValueError):
            validate_local_checksum_change(self.before, changed, self.spec, self.spec)


if __name__ == '__main__':
    unittest.main()
