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
        case 'getWidgetIds':
          return [];
        case 'reloadWidgets':
          return true;
        case 'widgetExist':
          return true;
        default:
      }
    });
  });

  group('iOS', () {
    setUp(() {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

      // AppWidgetPlatform.instance
    });

    tearDownAll(() {
      log.clear();
    });

    test('cancelConfigureWidget', () async {
      final appWidgetPlugin = AppWidgetPlugin();

      expect(
        appWidgetPlugin.cancelConfigureWidget(),
        throwsA(
          isA<Error>().having(
            (e) => e.toString().contains('LateInitializationError'),
            'LateInitializationError',
            isTrue,
          ),
        ),
      );
    });

    test('configureWidget', () async {
      final appWidgetPlugin = AppWidgetPlugin();

      expect(
        appWidgetPlugin.configureWidget(
          androidPackageName: '',
          widgetId: 1,
          itemId: 1,
          widgetLayout: '',
          textViewIdValueMap: {},
        ),
        throwsA(
          isA<Error>().having(
            (e) => e.toString().contains('LateInitializationError'),
            'LateInitializationError',
            isTrue,
          ),
        ),
      );
    });

    test('getWidgetIds', () async {
      final appWidgetPlugin = AppWidgetPlugin();

      expect(
        () => appWidgetPlugin.getWidgetIds(
          androidProviderName: 'TestProvider',
        ),
        throwsA(
          isA<Error>().having(
            (e) => e.toString().contains('LateInitializationError'),
            'LateInitializationError',
            isTrue,
          ),
        ),
      );
    });

    test('reloadWidgets', () async {
      final appWidgetPlugin = AppWidgetPlugin();

      expect(
        appWidgetPlugin.reloadWidgets(
          androidPackageName: 'com.example.app',
          androidProviderName: 'TestProvider',
        ),
        throwsA(
          isA<Error>().having(
            (e) => e.toString().contains('LateInitializationError'),
            'LateInitializationError',
            isTrue,
          ),
        ),
      );
    });

    test('updateWidget', () async {
      final appWidgetPlugin = AppWidgetPlugin();

      expect(
        appWidgetPlugin.updateWidget(
          androidPackageName: '',
          widgetId: 1,
          itemId: 1,
          widgetLayout: '',
          textViewIdValueMap: {},
        ),
        throwsA(
          isA<Error>().having(
            (e) => e.toString().contains('LateInitializationError'),
            'LateInitializationError',
            isTrue,
          ),
        ),
      );
    });

    test('widgetExist', () async {
      final appWidgetPlugin = AppWidgetPlugin();

      expect(
        appWidgetPlugin.widgetExist(12),
        throwsA(
          isA<Error>().having(
            (e) => e.toString().contains('LateInitializationError'),
            'LateInitializationError',
            isTrue,
          ),
        ),
      );
    });
  });
}
