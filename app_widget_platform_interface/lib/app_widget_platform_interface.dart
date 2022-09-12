
import 'app_widget_platform_interface_platform_interface.dart';

class AppWidgetPlatformInterface {
  Future<String?> getPlatformVersion() {
    return AppWidgetPlatformInterfacePlatform.instance.getPlatformVersion();
  }
}
