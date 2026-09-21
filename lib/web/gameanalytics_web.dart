import 'dart:async';
// Keep the Dart 2.12-compatible bridge; modern web interop needs a separate API migration.
// ignore: deprecated_member_use
import 'dart:html' as html show window;
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'gameanalytics_js.dart';

/// A web implementation of the Gameanalytics plugin.
class GameAnalyticsWeb {
  static final String VERSION = "1.3.1";

  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
      'gameanalytics',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = GameAnalyticsWeb();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
  }

  /// Handles method calls over the MethodChannel of this plugin.
  /// Note: Check the "federated" architecture for a new way of doing this:
  /// https://flutter.dev/go/federated-plugins
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getPlatformVersion':
        return getPlatformVersion();
      case 'configureAvailableCustomDimensions01':
        final String customDimensions = call.arguments["customDimensions"];
        final List<String> list =
            List<String>.from(jsonDecode(customDimensions));
        GameAnalyticsJS.configureAvailableCustomDimensions01(list);
        break;
      case 'configureAvailableCustomDimensions02':
        final String customDimensions = call.arguments["customDimensions"];
        final List<String> list =
            List<String>.from(jsonDecode(customDimensions));
        GameAnalyticsJS.configureAvailableCustomDimensions02(list);
        break;
      case 'configureAvailableCustomDimensions03':
        final String customDimensions = call.arguments["customDimensions"];
        final List<String> list =
            List<String>.from(jsonDecode(customDimensions));
        GameAnalyticsJS.configureAvailableCustomDimensions03(list);
        break;
      case 'configureAvailableResourceCurrencies':
        final String resourceCurrencies = call.arguments["resourceCurrencies"];
        final List<String> list =
            List<String>.from(jsonDecode(resourceCurrencies));
        GameAnalyticsJS.configureSdkGameEngineVersion("flutter " + VERSION);
        GameAnalyticsJS.configureAvailableResourceCurrencies(list);
        break;
      case 'configureAvailableResourceItemTypes':
        final String resourceItemTypes = call.arguments["resourceItemTypes"];
        final List<String> list =
            List<String>.from(jsonDecode(resourceItemTypes));
        GameAnalyticsJS.configureAvailableResourceItemTypes(list);
        break;
      case 'configureBuild':
        final String build = call.arguments["build"];
        GameAnalyticsJS.configureBuild(build);
        break;
      case 'configureAutoDetectAppVersion':
        // Not support no web platform
        break;
      case 'configureUserId':
        final String uId = call.arguments["uId"];
        GameAnalyticsJS.configureUserId(uId);
        break;
      case 'initialize':
        final String gameKey = call.arguments["gameKey"];
        final String secretKey = call.arguments["secretKey"];
        GameAnalyticsJS.initialize(gameKey, secretKey);
        break;
      case 'addBusinessEvent':
        final String currency = call.arguments["currency"];
        final int amount = call.arguments["amount"];
        final String itemType = call.arguments["itemType"];
        final String itemId = call.arguments["itemId"];
        final String cartType = call.arguments["cartType"];
        final Map fields = call.arguments.containsKey("customFields")
            ? jsonDecode(call.arguments["customFields"])
            : new Map();
        final bool mergeFields = call.arguments.containsKey("mergeFields")
            ? call.arguments["mergeFields"]
            : false;
        GameAnalyticsJS.addBusinessEvent(
            currency, amount, itemType, itemId, cartType, fields, mergeFields);
        break;
      case 'addResourceEvent':
        final int flowType = call.arguments["flowType"];
        final String currency = call.arguments["currency"];
        final double amount = call.arguments["amount"];
        final String itemType = call.arguments["itemType"];
        final String itemId = call.arguments["itemId"];
        final Map fields = call.arguments.containsKey("customFields")
            ? jsonDecode(call.arguments["customFields"])
            : new Map();
        final bool mergeFields = call.arguments.containsKey("mergeFields")
            ? call.arguments["mergeFields"]
            : false;
        GameAnalyticsJS.addResourceEvent(
            flowType, currency, amount, itemType, itemId, fields, mergeFields);
        break;
      case 'addProgressionEvent':
        final int flowType = call.arguments["progressionStatus"];
        final String progression01 = call.arguments["progression01"];
        final String progression02 = call.arguments.containsKey("progression02")
            ? call.arguments["progression02"]
            : "";
        final String progression03 = call.arguments.containsKey("progression03")
            ? call.arguments["progression03"]
            : "";
        final double? score = call.arguments.containsKey("score")
            ? call.arguments["score"]
            : null;
        final Map fields = call.arguments.containsKey("customFields")
            ? jsonDecode(call.arguments["customFields"])
            : new Map();
        final bool mergeFields = call.arguments.containsKey("mergeFields")
            ? call.arguments["mergeFields"]
            : false;
        GameAnalyticsJS.addProgressionEvent(flowType, progression01,
            progression02, progression03, score, fields, mergeFields);
        break;
      case 'addDesignEvent':
        final String eventId = call.arguments["eventId"];
        final double? value = call.arguments.containsKey("value")
            ? call.arguments["value"]
            : null;
        final Map fields = call.arguments.containsKey("customFields")
            ? jsonDecode(call.arguments["customFields"])
            : new Map();
        final bool mergeFields = call.arguments.containsKey("mergeFields")
            ? call.arguments["mergeFields"]
            : false;
        GameAnalyticsJS.addDesignEvent(eventId, value, fields, mergeFields);
        break;
      case 'addErrorEvent':
        final int severity = call.arguments["severity"];
        final String message = call.arguments["message"];
        final Map fields = call.arguments.containsKey("customFields")
            ? jsonDecode(call.arguments["customFields"])
            : new Map();
        final bool mergeFields = call.arguments.containsKey("mergeFields")
            ? call.arguments["mergeFields"]
            : false;
        GameAnalyticsJS.addErrorEvent(severity, message, fields, mergeFields);
        break;
      case 'addAdEvent':
        final int adAction = call.arguments["adAction"];
        final int adType = call.arguments["adType"];
        final String adSdkName = call.arguments["adSdkName"];
        final String adPlacement = call.arguments["adPlacement"];
        final Map fields = call.arguments.containsKey("customFields")
            ? jsonDecode(call.arguments["customFields"])
            : new Map();
        final bool mergeFields = call.arguments.containsKey("mergeFields")
            ? call.arguments["mergeFields"]
            : false;
        if (call.arguments.containsKey("noAdReason")) {
          final int noAdReason = call.arguments["noAdReason"];
          GameAnalyticsJS.addAdEventWithNoAdReason(adAction, adType, adSdkName,
              adPlacement, noAdReason, fields, mergeFields);
        } else if (call.arguments.containsKey("duration")) {
          final int duration = call.arguments["duration"];
          GameAnalyticsJS.addAdEventWithDuration(adAction, adType, adSdkName,
              adPlacement, duration, fields, mergeFields);
        } else {
          GameAnalyticsJS.addAdEvent(
              adAction, adType, adSdkName, adPlacement, fields, mergeFields);
        }
        break;
      case 'setEnabledInfoLog':
        final bool flag = call.arguments["flag"];
        GameAnalyticsJS.setEnabledInfoLog(flag);
        break;
      case 'setEnabledVerboseLog':
        final bool flag = call.arguments["flag"];
        GameAnalyticsJS.setEnabledVerboseLog(flag);
        break;
      case 'setEnabledManualSessionHandling':
        final bool flag = call.arguments["flag"];
        GameAnalyticsJS.setEnabledManualSessionHandling(flag);
        break;
      case 'setEnabledEventSubmission':
        final bool flag = call.arguments["flag"];
        GameAnalyticsJS.setEnabledEventSubmission(flag);
        break;
      case 'setCustomDimension01':
        final String dimension = call.arguments["dimension"];
        GameAnalyticsJS.setCustomDimension01(dimension);
        break;
      case 'setCustomDimension02':
        final String dimension = call.arguments["dimension"];
        GameAnalyticsJS.setCustomDimension02(dimension);
        break;
      case 'setCustomDimension03':
        final String dimension = call.arguments["dimension"];
        GameAnalyticsJS.setCustomDimension03(dimension);
        break;
      case 'setGlobalCustomEventFields':
        final Map fields = call.arguments.containsKey("customFields")
            ? jsonDecode(call.arguments["customFields"])
            : new Map();
        GameAnalyticsJS.setGlobalCustomEventFields(fields);
        break;
      case 'startSession':
        GameAnalyticsJS.startSession();
        break;
      case 'endSession':
        GameAnalyticsJS.endSession();
        break;
      case 'getRemoteConfigsValueAsString':
        final String key = call.arguments["key"];
        final String? defaultValue = call.arguments.containsKey("defaultValue")
            ? call.arguments["defaultValue"]
            : null;
        return Future.value(
            GameAnalyticsJS.getRemoteConfigsValueAsString(key, defaultValue));
      case 'isRemoteConfigsReady':
        return Future.value(GameAnalyticsJS.isRemoteConfigsReady());
      case 'getRemoteConfigsContentAsString':
        return Future.value(GameAnalyticsJS.getRemoteConfigsContentAsString());
      case 'getABTestingId':
        return Future.value(GameAnalyticsJS.getABTestingId());
      case 'getABTestingVariantId':
        return Future.value(GameAnalyticsJS.getABTestingVariantId());
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details:
              'gameanalytics for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  /// Returns a [String] containing the version of the platform.
  Future<String> getPlatformVersion() {
    final version = html.window.navigator.userAgent;
    return Future.value(version);
  }
}
