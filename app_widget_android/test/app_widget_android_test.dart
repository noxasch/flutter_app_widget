import 'package:flutter_test/flutter_test.dart';
import 'package:app_widget_android/app_widget_android.dart';
import 'package:app_widget_android/app_widget_android_platform_interface.dart';
import 'package:app_widget_android/app_widget_android_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppWidgetAndroidPlatform 
    with MockPlatformInterfaceMixin
    implements AppWidgetAndroidPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AppWidgetAndroidPlatform initialPlatform = AppWidgetAndroidPlatform.instance;

  test('$MethodChannelAppWidgetAndroid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppWidgetAndroid>());
  });

  test('getPlatformVersion', () async {
    AppWidgetAndroid appWidgetAndroidPlugin = AppWidgetAndroid();
    MockAppWidgetAndroidPlatform fakePlatform = MockAppWidgetAndroidPlatform();
    AppWidgetAndroidPlatform.instance = fakePlatform;
  
    expect(await appWidgetAndroidPlugin.getPlatformVersion(), '42');
  });
}
