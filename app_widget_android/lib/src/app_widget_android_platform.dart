import 'package:app_widget_platform_interface/app_widget_platform_interface.dart';

class AppWidgetAndroid extends AppWidgetPlatform {
  // this is use by flutter pluginRegistrant
  static void registerWith() {
    AppWidgetPlatform.instance = AppWidgetAndroid();
  }
}
