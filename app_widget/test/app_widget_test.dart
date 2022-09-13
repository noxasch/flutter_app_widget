import 'package:app_widget/app_widget.dart';

import 'package:app_widget_platform_interface/app_widget_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAppWidgetPlatform
    with MockPlatformInterfaceMixin
    implements AppWidgetPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future configureWidget() {
    // TODO: implement configureWidget
    throw UnimplementedError();
  }

  @override
  Future updateWidget() {
    // TODO: implement updateWidget
    throw UnimplementedError();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // final AppWidgetPlatform initialPlatform = AppWidgetPlatform.instance;

  // test('Null is the default instance', () {
  //   expect(initialPlatform, isNull);
  // });

  test('getPlatformVersion', () async {
    AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin();
    MockAppWidgetPlatform fakePlatform = MockAppWidgetPlatform();
    AppWidgetPlatform.instance = fakePlatform;

    expect(await appWidgetPlugin.getPlatformVersion(), '42');
  });
}
