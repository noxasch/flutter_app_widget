import 'package:app_widget_android/app_widget_android.dart';
import 'package:app_widget_platform_interface/app_widget_platform_interface.dart';
import 'package:flutter/foundation.dart';

class AppWidgetPlugin {
  final VoidCallback? onConfigureWidget;

  factory AppWidgetPlugin({VoidCallback? onConfigureWidget}) {
    if (_instance != null) return _instance!;
    _instance = AppWidgetPlugin._(onConfigureWidget: onConfigureWidget);

    return _instance!;
  }

  AppWidgetPlugin._({this.onConfigureWidget}) {
    if (kIsWeb) {
      return;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      AppWidgetPlatform.instance =
          AppWidgetAndroidPlugin(onConfigureWidget: onConfigureWidget);
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return;
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      return;
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      return;
    }
  }

  static AppWidgetPlugin? _instance;

  // @override
  Future<String?> getPlatformVersion() {
    return AppWidgetPlatform.instance.getPlatformVersion();
  }
}
