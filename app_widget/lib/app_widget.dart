
import 'app_widget_platform_interface.dart';

class AppWidget {
  Future<String?> getPlatformVersion() {
    return AppWidgetPlatform.instance.getPlatformVersion();
  }
}
