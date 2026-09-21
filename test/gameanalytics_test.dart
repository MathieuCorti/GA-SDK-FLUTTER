import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gameanalytics_sdk/gameanalytics.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('gameanalytics');
  final binaryMessenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    binaryMessenger.setMockMethodCallHandler(channel, (methodCall) async {
      calls.add(methodCall);

      switch (methodCall.method) {
        case 'isRemoteConfigsReady':
          return true;
        case 'getRemoteConfigsValueAsString':
          return 'remote-value';
        case 'getRemoteConfigsContentAsString':
          return '{"debug_menu":"enabled"}';
        case 'getABTestingId':
          return 'experiment-id';
        case 'getABTestingVariantId':
          return 'variant-id';
      }

      return null;
    });
  });

  tearDown(() {
    binaryMessenger.setMockMethodCallHandler(channel, null);
  });

  group('GameAnalytics Dart API', () {
    test('forwards initialization and logging calls', () async {
      await GameAnalytics.setEnabledInfoLog(true);
      await GameAnalytics.setEnabledVerboseLog(false);
      await GameAnalytics.configureAutoDetectAppVersion(true);
      await GameAnalytics.initialize('game-key', 'secret-key');

      expect(
        calls.map((call) => call.method),
        <String>[
          'setEnabledInfoLog',
          'setEnabledVerboseLog',
          'configureAutoDetectAppVersion',
          'initialize',
        ],
      );
      expect(calls[0].arguments, <String, Object>{'flag': true});
      expect(calls[1].arguments, <String, Object>{'flag': false});
      expect(calls[2].arguments, <String, Object>{'flag': true});
      expect(
        calls[3].arguments,
        <String, Object>{'gameKey': 'game-key', 'secretKey': 'secret-key'},
      );
    });

    test('forwards events and session calls', () async {
      await GameAnalytics.addDesignEvent(<String, Object>{
        'eventId': 'debug:testEvent',
        'value': 1,
      });
      await GameAnalytics.startSession();
      await GameAnalytics.endSession();

      expect(
        calls.map((call) => call.method),
        <String>['addDesignEvent', 'startSession', 'endSession'],
      );
      expect(
        calls.first.arguments,
        <String, Object>{'eventId': 'debug:testEvent', 'value': 1},
      );
    });

    test('forwards Remote Config reads', () async {
      expect(
        await GameAnalytics.getRemoteConfigsValueAsString(
          'debug_menu',
          'disabled',
        ),
        'remote-value',
      );
      expect(await GameAnalytics.isRemoteConfigsReady(), isTrue);
      expect(
        await GameAnalytics.getRemoteConfigsContentAsString(),
        '{"debug_menu":"enabled"}',
      );
      expect(await GameAnalytics.getABTestingId(), 'experiment-id');
      expect(await GameAnalytics.getABTestingVariantId(), 'variant-id');

      expect(
        calls.map((call) => call.method),
        <String>[
          'getRemoteConfigsValueAsString',
          'isRemoteConfigsReady',
          'getRemoteConfigsContentAsString',
          'getABTestingId',
          'getABTestingVariantId',
        ],
      );
      expect(
        calls.first.arguments,
        <String, Object>{
          'key': 'debug_menu',
          'defaultValue': 'disabled',
        },
      );
    });
  });
}
