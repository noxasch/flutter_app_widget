import 'package:app_widget_android/app_widget_android.dart';
import 'package:app_widget_platform_interface/app_widget_platform_interface.dart';
import 'package:flutter/foundation.dart';

class AppWidgetPlugin {
  /// callback function when the widget is first created
  late final void Function(int widgetId)? _onConfigureWidget;

  /// payload keys:
  /// - itemId
  /// - stringUid
  /// - widgetId
  late final void Function(Map<String, dynamic> payload)? _onClickWidget;

  factory AppWidgetPlugin({
    void Function(int widgetId)? onConfigureWidget,
    void Function(Map<String, dynamic> payload)? onClickWidget,
  }) {
    if (instance != null) return instance!;
    instance = AppWidgetPlugin._(
      onConfigureWidget: onConfigureWidget,
      onClickWidget: onClickWidget,
    );

    return instance!;
  }

  AppWidgetPlugin._({
    required void Function(int widgetId)? onConfigureWidget,
    required void Function(Map<String, dynamic> payload)? onClickWidget,
  }) {
    _onConfigureWidget = onConfigureWidget;
    _onClickWidget = onClickWidget;

    if (kIsWeb) {
      return;
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      AppWidgetPlatform.instance = AppWidgetAndroidPlugin(
        onConfigureWidget: _onConfigureWidget,
        onClickWidget: _onClickWidget,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return;
    }
  }

  static AppWidgetPlugin? instance;

  /// Configure Widget for the first time
  ///
  /// widgetId is from configureWidget event
  Future<bool?> configureWidget({
    required String androidAppName,
    required int widgetId,
    required String widgetLayout,
    Map<String, String>? textViewIdValueMap,
    int? itemId,
    String? stringUid,
  }) async {
    return AppWidgetPlatform.instance.configureWidget(
      androidAppName: androidAppName,
      widgetId: widgetId,
      widgetLayout: widgetLayout,
      textViewIdValueMap: textViewIdValueMap,
      itemId: itemId,
      stringUid: stringUid,
    );
  }

  /// check if widget with given Id exist
  ///
  Future<bool?> widgetExist(int widgetId) async {
    return AppWidgetPlatform.instance.widgetExist(widgetId);
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
