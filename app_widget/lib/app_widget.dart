import 'package:app_widget_platform_interface/app_widget_platform_interface.dart';

Future<String?> getPlatformVersion() {
  return AppWidgetPlatform.instance.getPlatformVersion();
}
