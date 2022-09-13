import 'package:app_widget_platform_interface/app_widget_platform_interface.dart';
import 'package:flutter/services.dart';

const MethodChannel _methodChannel =
    MethodChannel('tech.noxasch/app_widget_android');

class AppWidgetAndroid extends AppWidgetPlatform {
  // this is use by flutter pluginRegistrant
  static void registerWith() {
    AppWidgetPlatform.instance = AppWidgetAndroid();
  }

  @override
  Future<String?> getPlatformVersion() {
    return _methodChannel.invokeMethod('getPlatformVersion');
  }
}
