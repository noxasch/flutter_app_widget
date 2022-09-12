import 'package:flutter_test/flutter_test.dart';
import 'package:app_widget/app_widget.dart';
import 'package:app_widget/app_widget_platform_interface.dart';
import 'package:app_widget/app_widget_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppWidgetPlatform 
    with MockPlatformInterfaceMixin
    implements AppWidgetPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AppWidgetPlatform initialPlatform = AppWidgetPlatform.instance;

  test('$MethodChannelAppWidget is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAppWidget>());
  });

  test('getPlatformVersion', () async {
    AppWidget appWidgetPlugin = AppWidget();
    MockAppWidgetPlatform fakePlatform = MockAppWidgetPlatform();
    AppWidgetPlatform.instance = fakePlatform;
  
    expect(await appWidgetPlugin.getPlatformVersion(), '42');
  });
}
