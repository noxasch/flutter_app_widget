import 'package:app_widget_android/app_widget_android.dart';
import 'package:app_widget_platform_interface/app_widget_platform_interface.dart';
import 'package:flutter/foundation.dart';

class AppWidgetPlugin {
  /// callback function when the widget is first created
  final void Function(int widgetId)? onConfigureWidget;

  /// callback on app interval update
  final void Function(List<int> widgetIds)? onUpdateWidgets;

  /// callback when app is deleted
  ///
  /// can be used for cleanup if you store widget related somewhere
  final void Function(List<int> widgetIds)? onDeletedWidgets;

  /// payload keys:
  /// - itemId
  /// - stringUid
  /// - widgetId
  final void Function(Map<String, dynamic> payload)? onClickWidget;

  factory AppWidgetPlugin({
    void Function(int widgetId)? onConfigureWidget,
    void Function(List<int> widgetIds)? onUpdateWidgets,
    void Function(List<int> widgetIds)? onDeletedWidgets,
    void Function(Map<String, dynamic> payload)? onClickWidget,
  }) {
    if (_instance != null) return _instance!;
    _instance = AppWidgetPlugin._(
      onConfigureWidget: onConfigureWidget,
      onUpdateWidgets: onUpdateWidgets,
      onDeletedWidgets: onDeletedWidgets,
      onClickWidget: onClickWidget,
    );

    return _instance!;
  }

  AppWidgetPlugin._({
    this.onConfigureWidget,
    this.onUpdateWidgets,
    this.onDeletedWidgets,
    this.onClickWidget,
  }) {
    if (kIsWeb) {
      return;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      AppWidgetPlatform.instance = AppWidgetAndroidPlugin(
        onConfigureWidget: onConfigureWidget,
        onUpdateWidgets: onUpdateWidgets,
        onDeletedWidgets: onDeletedWidgets,
        onClickWidget: onClickWidget,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return;
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      return;
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      return;
    }
  }

  static AppWidgetPlugin? _instance;

  // remove this, this is just to make sure the plugin is working
  Future<String?> getPlatformVersion() {
    return AppWidgetPlatform.instance.getPlatformVersion();
  }

  /// Configure Widget for the first time
  ///
  /// widgetId is from configureWidget event
  Future<bool?> configureWidget({
    required String androidAppName,
    required int widgetId,
    required String widgetLayout,
    required String widgetContainerName,
    Map<String, String>? textViewIdValueMap,
    int? itemId,
  }) async {
    return AppWidgetPlatform.instance.configureWidget(
      androidAppName: androidAppName,
      widgetId: widgetId,
      widgetLayout: widgetLayout,
      widgetContainerName: widgetContainerName,
      textViewIdValueMap: textViewIdValueMap,
      itemId: itemId,
    );
  }

  /// Cancel widget configuration
  ///
  /// this will send Activity.RESULT_CANCELLED on android
  Future<bool?> cancelConfigureWidget() async {
    return AppWidgetPlatform.instance.cancelConfigureWidget();
  }

  /// reload all widgets
  Future<bool?> reloadWidgets({
    required String androidAppName,
    required String androidProviderName,
  }) async {
    return AppWidgetPlatform.instance.reloadWidgets(
      androidAppName: androidAppName,
      androidProviderName: androidProviderName,
    );
  }
}
