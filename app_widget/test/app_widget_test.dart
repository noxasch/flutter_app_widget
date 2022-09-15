import 'package:app_widget/app_widget.dart';
import 'package:app_widget_platform_interface/app_widget_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(AppWidgetPlatform.channel);
  final List<MethodCall> log = <MethodCall>[];

  setUpAll(() {
    // ignore: always_specify_types
    channel.setMockMethodCallHandler((methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'getPlatformVersion':
          return '42';
        case 'configureWidget':
          return true;
        case 'cancelConfigureWidget':
          return true;
        case 'reloadWidgets':
          return true;
        case 'updateWidget':
          return true;
        case 'widgetExist':
          return true;
        default:
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
      final appWidgetPlugin = AppWidgetPlugin();

      expect(
        appWidgetPlugin.configureWidget(
          androidAppName: 'appname',
          widgetId: 1,
          itemId: 1,
          widgetLayout: 'layoutname',
          textViewIdValueMap: {},
          stringUid: 'uid',
        ),
        completion(true),
      );

      expect(log, <Matcher>[
        isMethodCall(
          'configureWidget',
          arguments: <String, Object>{
            'androidAppName': 'appname',
            'widgetId': 1,
            'itemId': 1,
            'widgetLayout': 'layoutname',
            'textViewIdValueMap': {},
            'stringUid': 'uid'
          },
        )
      ]);
    });

    test('updateWidget', () async {
      final appWidgetPlugin = AppWidgetPlugin();

      expect(
        appWidgetPlugin.updateWidget(
          androidAppName: 'appname',
          widgetId: 1,
          itemId: 1,
          widgetLayout: 'layoutname',
          textViewIdValueMap: {},
          stringUid: 'uid',
        ),
        completion(true),
      );

      expect(log, <Matcher>[
        isMethodCall(
          'updateWidget',
          arguments: <String, Object>{
            'androidAppName': 'appname',
            'widgetId': 1,
            'itemId': 1,
            'widgetLayout': 'layoutname',
            'textViewIdValueMap': {},
            'stringUid': 'uid'
          },
        )
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
        )
      ]);
    });

    test('reloadWidgets', () async {
      final appWidgetPlugin = AppWidgetPlugin();

      expect(
        appWidgetPlugin.reloadWidgets(
          androidAppName: 'com.example.app',
          androidProviderName: 'TestProvider',
        ),
        completion(true),
      );

      expect(log, <Matcher>[
        isMethodCall(
          'reloadWidgets',
          arguments: <String, Object>{
            'androidAppName': 'com.example.app',
            'androidProviderName': 'TestProvider',
          },
        )
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
        )
      ]);
    });
  });
}
