// ignore_for_file: inference_failure_on_collection_literal

import 'package:app_widget/app_widget.dart';
import 'package:app_widget_platform_interface/app_widget_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

// NOTE: this merely test platform specific (android) interface
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(AppWidgetPlatform.channel);
  final List<MethodCall> log = <MethodCall>[];

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'getPlatformVersion':
          return '42';
        case 'configureWidget':
          return true;
        case 'cancelConfigureWidget':
          return true;
        case 'getWidgetIds':
          return [42];
        case 'reloadWidgets':
          return true;
        case 'updateWidget':
          return true;
        case 'widgetExist':
          return true;
        default:
          return false;
      }
    });
  });

  group('Android', () {
    setUp(() {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
    });

    tearDown(() {
      log.clear();
    });

    test('configureWidget', () async {
      final appWidgetPlugin = AppWidgetPlugin(
        androidPackageName: 'appname',
      );

      expect(
        appWidgetPlugin.configureWidget(
          widgetId: 1,
          layoutId: 1,
          payload: '{"itemId": 1, "stringUid": "uid"}',
          url: 'https://google.come',
        ),
        completion(true),
      );

      expect(log, <Matcher>[
        isMethodCall(
          'configureWidget',
          arguments: <String, Object>{
            'androidPackageName': 'appname',
            'widgetId': 1,
            'layoutId': 1,
            'textViews': {},
            'payload': '{"itemId": 1, "stringUid": "uid"}',
            'url': 'https://google.come',
          },
        ),
      ]);
    });

    test('configureWidget diff package name', () async {
      final appWidgetPlugin = AppWidgetPlugin(
        androidPackageName: 'appname',
      );

      expect(
        appWidgetPlugin.configureWidget(
          widgetId: 1,
          layoutId: 1,
          payload: '{"itemId": 1, "stringUid": "uid"}',
          url: 'https://google.come',
          androidPackageName: 'appname2',
        ),
        completion(true),
      );

      expect(log, <Matcher>[
        isMethodCall(
          'configureWidget',
          arguments: <String, Object>{
            'androidPackageName': 'appname2',
            'widgetId': 1,
            'layoutId': 1,
            'textViews': {},
            'payload': '{"itemId": 1, "stringUid": "uid"}',
            'url': 'https://google.come',
          },
        ),
      ]);
    });

    test('updateWidget', () async {
      final appWidgetPlugin = AppWidgetPlugin(
        androidPackageName: 'appname',
      );

      expect(
        appWidgetPlugin.updateWidget(
          widgetId: 1,
          layoutId: 1,
          payload: '{"itemId": 1, "stringUid": "uid"}',
          url: 'https://google.come',
        ),
        completion(true),
      );

      expect(log, <Matcher>[
        isMethodCall(
          'updateWidget',
          arguments: <String, Object>{
            'androidPackageName': 'appname',
            'widgetId': 1,
            'layoutId': 1,
            'textViews': {},
            'payload': '{"itemId": 1, "stringUid": "uid"}',
            'url': 'https://google.come',
          },
        ),
      ]);
    });

    test('updateWidget different widget package name', () async {
      final appWidgetPlugin = AppWidgetPlugin(
        androidPackageName: 'appname',
      );

      expect(
        appWidgetPlugin.updateWidget(
          androidPackageName: 'appname2',
          widgetId: 1,
          layoutId: 1,
          payload: '{"itemId": 1, "stringUid": "uid"}',
          url: 'https://google.come',
        ),
        completion(true),
      );

      expect(log, <Matcher>[
        isMethodCall(
          'updateWidget',
          arguments: <String, Object>{
            'androidPackageName': 'appname2',
            'widgetId': 1,
            'layoutId': 1,
            'textViews': {},
            'payload': '{"itemId": 1, "stringUid": "uid"}',
            'url': 'https://google.come',
          },
        ),
      ]);
    });

    test('cancelConfigureWidget', () async {
      final appWidgetPlugin = AppWidgetPlugin();

      expect(
        appWidgetPlugin.cancelConfigureWidget(),
        completion(true),
      );

      expect(log, <Matcher>[
        isMethodCall(
          'cancelConfigureWidget',
          arguments: null,
        ),
      ]);
    });

    test('getWidgetIds', () async {
      final appWidgetPlugin = AppWidgetPlugin();

      expect(
        appWidgetPlugin.getWidgetIds(
          androidProviderName: 'TestProvider',
        ),
        completion([42]),
      );

      expect(log, <Matcher>[
        isMethodCall(
          'getWidgetIds',
          arguments: <String, Object>{
            'androidProviderName': 'TestProvider',
            'androidPackageName': 'appname',
          },
        ),
      ]);
    });

    test('getWidgetIds diff package name', () async {
      final appWidgetPlugin = AppWidgetPlugin();

      expect(
        appWidgetPlugin.getWidgetIds(
          androidProviderName: 'TestProvider',
          androidPackageName: 'appname2',
        ),
        completion([42]),
      );

      expect(log, <Matcher>[
        isMethodCall(
          'getWidgetIds',
          arguments: <String, Object>{
            'androidProviderName': 'TestProvider',
            'androidPackageName': 'appname2',
          },
        ),
      ]);
    });

    test('reloadWidgets', () async {
      final appWidgetPlugin = AppWidgetPlugin();

      expect(
        appWidgetPlugin.reloadWidgets(
          androidProviderName: 'TestProvider',
        ),
        completion(true),
      );

      expect(log, <Matcher>[
        isMethodCall(
          'reloadWidgets',
          arguments: <String, Object>{
            'androidProviderName': 'TestProvider',
            'androidPackageName': 'appname',
          },
        ),
      ]);
    });

    test('reloadWidgets diff package name', () async {
      final appWidgetPlugin = AppWidgetPlugin();

      expect(
        appWidgetPlugin.reloadWidgets(
          androidProviderName: 'TestProvider',
          androidPackageName: 'appname2',
        ),
        completion(true),
      );

      expect(log, <Matcher>[
        isMethodCall(
          'reloadWidgets',
          arguments: <String, Object>{
            'androidProviderName': 'TestProvider',
            'androidPackageName': 'appname2',
          },
        ),
      ]);
    });

    test('widgetExist', () async {
      final appWidgetPlugin = AppWidgetPlugin();

      expect(
        appWidgetPlugin.widgetExist(12),
        completion(true),
      );

      expect(log, <Matcher>[
        isMethodCall(
          'widgetExist',
          arguments: <String, Object>{
            'widgetId': 12,
          },
        ),
      ]);
    });
  });
}
