import 'package:flutter_test/flutter_test.dart';
import 'package:app_widget_platform_interface/app_widget_platform_interface.dart';
import 'package:app_widget_platform_interface/app_widget_platform_interface_platform_interface.dart';
import 'package:app_widget_platform_interface/app_widget_platform_interface_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppWidgetPlatformInterfacePlatform 
    with MockPlatformInterfaceMixin
    implements AppWidgetPlatformInterfacePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AppWidgetPlatformInterfacePlatform initialPlatform = AppWidgetPlatformInterfacePlatform.instance;

  test('$MethodChannelAppWidgetPlatformInterface is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppWidgetPlatformInterface>());
  });

  test('getPlatformVersion', () async {
    AppWidgetPlatformInterface appWidgetPlatformInterfacePlugin = AppWidgetPlatformInterface();
    MockAppWidgetPlatformInterfacePlatform fakePlatform = MockAppWidgetPlatformInterfacePlatform();
    AppWidgetPlatformInterfacePlatform.instance = fakePlatform;
  
    expect(await appWidgetPlatformInterfacePlugin.getPlatformVersion(), '42');
  });
}
