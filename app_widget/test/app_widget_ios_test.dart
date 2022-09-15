import 'package:app_widget/app_widget.dart';
import 'package:app_widget_platform_interface/app_widget_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAppWidgetPugin implements AppWidgetPlugin {
  @override
  Future<bool> cancelConfigureWidget() async {
    return true;
  }

  @override
  Future<bool> configureWidget({
    required String androidAppName,
    required int widgetId,
    required String widgetLayout,
    Map<String, String>? textViewIdValueMap,
    int? itemId,
    String? stringUid,
  }) async {
    return true;
  }

  @override
  Future<bool> reloadWidgets({
    required String androidAppName,
    required String androidProviderName,
  }) async {
    return true;
  }

  @override
  Future<bool> widgetExist(int widgetId) async {
    return true;
  }

  @override
  Future<bool?> updateWidget({
    required String androidAppName,
    required int widgetId,
    required String widgetLayout,
    Map<String, String>? textViewIdValueMap,
    int? itemId,
    String? stringUid,
  }) async {
    return true;
  }
}

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

    test('configureWidget', () async {
      final appWidgetPlugin = AppWidgetPlugin();

      expect(
        appWidgetPlugin.configureWidget(
          androidAppName: '',
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

    test('updateWidget', () async {
      final appWidgetPlugin = AppWidgetPlugin();

      expect(
        appWidgetPlugin.updateWidget(
          androidAppName: '',
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

    test('reloadWidgets', () async {
      final appWidgetPlugin = AppWidgetPlugin();

      expect(
        appWidgetPlugin.reloadWidgets(
          androidAppName: 'com.example.app',
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
