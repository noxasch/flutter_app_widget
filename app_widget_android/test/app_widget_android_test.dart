import 'package:app_widget_android/app_widget_android.dart';
import 'package:app_widget_platform_interface/app_widget_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppWidgetAndroidPlatform
    with MockPlatformInterfaceMixin
    implements AppWidgetPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> configureWidget() {
    // TODO: implement configureWidget
    throw UnimplementedError();
  }

  @override
  Future<void> updateWidget() {
    // TODO: implement updateWidget
    throw UnimplementedError();
  }
}

void main() {
  final AppWidgetPlatform initialPlatform = MockAppWidgetAndroidPlatform();

  test('$AppWidgetAndroid is the default instance', () {
    expect(initialPlatform, isInstanceOf<AppWidgetAndroid>());
  });

  test('getPlatformVersion', () async {
    AppWidgetPlatform appWidgetAndroidPlugin = MockAppWidgetAndroidPlatform();
    MockAppWidgetAndroidPlatform fakePlatform = MockAppWidgetAndroidPlatform();
    AppWidgetPlatform.instance = fakePlatform;

    expect(await appWidgetAndroidPlugin.getPlatformVersion(), '42');
  });
}
