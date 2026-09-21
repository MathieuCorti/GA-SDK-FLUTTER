import 'package:flutter/material.dart';
import 'dart:async';

import 'package:gameanalytics_sdk/gameanalytics.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    GameAnalytics.setEnabledInfoLog(true);
    GameAnalytics.setEnabledVerboseLog(true);

    GameAnalytics.configureAvailableCustomDimensions01(["ninja", "samurai"]);
    GameAnalytics.configureAvailableCustomDimensions02(["whale", "dolphin"]);
    GameAnalytics.configureAvailableCustomDimensions03(["horde", "alliance"]);
    GameAnalytics.configureAvailableResourceCurrencies(["gems", "gold"]);
    GameAnalytics.configureAvailableResourceItemTypes(["boost", "lives"]);
    GameAnalytics.configureBuild("0.1.0");
    GameAnalytics.configureAutoDetectAppVersion(true);
    GameAnalytics.initialize("c6cfc80ff69d1e7316bf1e0c8194eda6",
        "e0ae4809f70e2fa96916c7060f417ae53895f18d");

    GameAnalytics.setCustomDimension01("ninja");
    GameAnalytics.setCustomDimension02("dolphin");
    GameAnalytics.setCustomDimension03("alliance");

    GameAnalytics.addBusinessEvent({
      "currency": "USD",
      "amount": 99,
      "itemType": "weapons",
      "itemId": "shotgun",
      "cartType": "end_of_level"
    });
    GameAnalytics.addBusinessEvent({
      "currency": "USD",
      "amount": 99,
      "itemType": "weapons",
      "itemId": "shotgun",
      "cartType": "end_of_level",
      "receipt": "test_receipt",
      "signature": "test_signature"
    });
    GameAnalytics.addResourceEvent({
      "flowType": GAResourceFlowType.Source,
      "currency": "gems",
      "amount": 100,
      "itemType": "lives",
      "itemId": "5lives"
    });
    GameAnalytics.addProgressionEvent({
      "progressionStatus": GAProgressionStatus.Start,
      "progression01": "world01",
      "progression02": "level01",
      "progression03": "phase01",
      "itemId": "5lives"
    });
    GameAnalytics.addProgressionEvent({
      "progressionStatus": GAProgressionStatus.Complete,
      "progression01": "world01",
      "progression02": "level01",
      "progression03": "phase01",
      "score": 666
    });
    GameAnalytics.addDesignEvent({"eventId": "some:event"});
    GameAnalytics.addDesignEvent({"eventId": "some:other:event", "value": 666});
    GameAnalytics.addErrorEvent({
      "severity": GAErrorSeverity.Error,
      "message": "This is an error message!!!"
    });
    GameAnalytics.addAdEvent({
      "adAction": GAAdAction.Show,
      "adType": GAAdType.Interstitial,
      "adSdkName": "mopub",
      "adPlacement": "end_of_level"
    });
  }

  Future<void> printRemoteConfigsInfo() async {
    String content =
        await GameAnalytics.getRemoteConfigsContentAsString() ?? "";
    print("content=" + content);
    bool isReady = await GameAnalytics.isRemoteConfigsReady();
    print("isReady=" + isReady.toString());
    String value = await GameAnalytics.getRemoteConfigsValueAsString(
            "unicode_key", "null") ??
        "null";
    print("value=" + value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: TextButton(
              child: Text('Test'),
              onPressed: () {
                printRemoteConfigsInfo();
              }),
        ),
      ),
    );
  }
}
