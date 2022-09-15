import 'package:app_widget_platform_interface/app_widget_platform_interface.dart';

class AppWidgetAndroid extends AppWidgetPlatform {
  // this is use by flutter pluginRegistrant
  // this will register with no callback
  // no methodChannel are allowed since this are call before the app
  static void registerWith() {
    AppWidgetPlatform.instance = AppWidgetAndroid();
  }
}
