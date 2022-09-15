import 'package:app_widget_android/app_widget_android.dart';
import 'package:app_widget_platform_interface/app_widget_platform_interface.dart';

class AppWidgetAndroid extends AppWidgetPlatform {
  // this is use by flutter pluginRegistrant
  // this will register with no callback
  static void registerWith() {
    AppWidgetPlatform.instance = AppWidgetAndroidPlugin();
  }
}
