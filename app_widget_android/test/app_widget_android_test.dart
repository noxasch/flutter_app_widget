// ignore_for_file: inference_failure_on_collection_literal

import 'package:app_widget_android/app_widget_android.dart';
import 'package:app_widget_platform_interface/app_widget_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

void main() {
  final AppWidgetPlatform initialPlatform = MockAppWidgetAndroidPlatform();

  test('$AppWidgetAndroid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MockAppWidgetAndroidPlatform>());
  });

  test('cancelConfigureWidget', () async {
    AppWidgetPlatform appWidgetAndroidPlugin = MockAppWidgetAndroidPlatform();
    MockAppWidgetAndroidPlatform fakePlatform = MockAppWidgetAndroidPlatform();
    AppWidgetPlatform.instance = fakePlatform;

    expect(await appWidgetAndroidPlugin.cancelConfigureWidget(), isTrue);
  });

  test('configureWidget', () async {
    AppWidgetPlatform appWidgetAndroidPlugin = MockAppWidgetAndroidPlatform();
    MockAppWidgetAndroidPlatform fakePlatform = MockAppWidgetAndroidPlatform();
    AppWidgetPlatform.instance = fakePlatform;

    expect(await appWidgetAndroidPlugin.configureWidget(), isTrue);
  });

  test('getWidgetIds', () async {
    AppWidgetPlatform appWidgetAndroidPlugin = MockAppWidgetAndroidPlatform();
    MockAppWidgetAndroidPlatform fakePlatform = MockAppWidgetAndroidPlatform();
    AppWidgetPlatform.instance = fakePlatform;

    expect(
      await appWidgetAndroidPlugin.getWidgetIds(androidProviderName: 'name'),
      [42],
    );
  });

  test('reloadWidgets', () async {
    AppWidgetPlatform appWidgetAndroidPlugin = MockAppWidgetAndroidPlatform();
    MockAppWidgetAndroidPlatform fakePlatform = MockAppWidgetAndroidPlatform();
    AppWidgetPlatform.instance = fakePlatform;

    expect(await appWidgetAndroidPlugin.reloadWidgets(), isTrue);
  });

  test('updateWidget', () async {
    AppWidgetPlatform appWidgetAndroidPlugin = MockAppWidgetAndroidPlatform();
    MockAppWidgetAndroidPlatform fakePlatform = MockAppWidgetAndroidPlatform();
    AppWidgetPlatform.instance = fakePlatform;

    expect(await appWidgetAndroidPlugin.cancelConfigureWidget(), isTrue);
  });

  test('widgetExist', () async {
    AppWidgetPlatform appWidgetAndroidPlugin = MockAppWidgetAndroidPlatform();
    MockAppWidgetAndroidPlatform fakePlatform = MockAppWidgetAndroidPlatform();
    AppWidgetPlatform.instance = fakePlatform;

    expect(await appWidgetAndroidPlugin.widgetExist(1), isTrue);
  });
}

class MockAppWidgetAndroidPlatform
    with MockPlatformInterfaceMixin
    implements AppWidgetPlatform {
  @override
  Future<bool?> cancelConfigureWidget() async {
    return true;
  }

  @override
  Future<bool?> configureWidget({
    String? androidPackageName,
    int? widgetId,
    String? widgetLayout,
    String? widgetContainerName,
    Map<String, String>? textViewIdValueMap,
    int? itemId,
    String? stringUid,
  }) async {
    return true;
  }

  @override
  Future<bool?> reloadWidgets({
    String? androidPackageName,
    String? androidProviderName,
  }) async {
    return true;
  }

  @override
  Future<bool?> updateWidget({
    String? androidPackageName,
    int? widgetId,
    String? widgetLayout,
    Map<String, String>? textViewIdValueMap,
    int? itemId,
    String? stringUid,
  }) async {
    return true;
  }

  @override
  Future<bool?> widgetExist(int widgetId) async {
    return true;
  }

  @override
  Future<List<int>?> getWidgetIds({String? androidProviderName}) async {
    return [42];
  }
}
