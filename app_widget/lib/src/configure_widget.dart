import 'package:app_widget_platform_interface/app_widget_platform_interface.dart';

// in app need to call this before configureWidget or other method
// final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin();

Future<void> configureWidget() async {
  return AppWidgetPlatform.instance.configureWidget();
}
