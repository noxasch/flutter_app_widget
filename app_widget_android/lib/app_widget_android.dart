
import 'app_widget_android_platform_interface.dart';

class AppWidgetAndroid {
  Future<String?> getPlatformVersion() {
    return AppWidgetAndroidPlatform.instance.getPlatformVersion();
  }
}
