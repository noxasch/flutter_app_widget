import 'package:app_widget_android/app_widget_android.dart';
import 'package:app_widget_platform_interface/app_widget_platform_interface.dart';
import 'package:flutter/foundation.dart';

/// Instantiate plugin instance and register callback optional callback
///
/// Accept an optional [androidPackageName] string which use to properly works for flavor that have different package name
/// than the packageName for MainActivity  <br>
/// Accept [onConfigureWidget] callback method - optional <br>
/// Accept [onClickWidget] callback method - optional <br>
///
/// onClickWidget payload:
///
/// ```dart
/// {
///  "widgetId" : 23,
///  "itemId": 232,  // (if set during update/configure otherwise it is null)
///  "stringUid": "dadas", // (if set during update/configure otherwise it is null)
/// }
/// ```
///
class AppWidgetPlugin {
  factory AppWidgetPlugin({
    String? androidPackageName,

    /// callback function when the widget is first created
    void Function(int widgetId)? onConfigureWidget,
    void Function(String? payload)? onClickWidget,
  }) {
    if (instance != null) return instance!;
    instance = AppWidgetPlugin._(
      androidPackageName: androidPackageName,
      onConfigureWidget: onConfigureWidget,
      onClickWidget: onClickWidget,
    );

    return instance!;
  }

  AppWidgetPlugin._({
    required String? androidPackageName,
    required void Function(int widgetId)? onConfigureWidget,
    required void Function(String? payload)? onClickWidget,
  })  : _onConfigureWidget = onConfigureWidget,
        _onClickWidget = onClickWidget,
        _androidPackageName = androidPackageName {
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

  final String? _androidPackageName;

  /// callback function when the widget is first created
  final void Function(int widgetId)? _onConfigureWidget;

  /// payload keys:
  /// - itemId
  /// - stringUid
  /// - widgetId
  final void Function(String? payload)? _onClickWidget;

  /// Cancel widget configuration
  ///
  /// this will send Activity.RESULT_CANCELLED on android
  Future<bool?> cancelConfigureWidget() async {
    return AppWidgetPlatform.instance.cancelConfigureWidget();
  }

  /// Configure Widget for the first time
  ///
  /// [androidPackageName] should be the app package name.
  /// eg: com.example.myapp
  ///
  /// [widgetLayout] is the layout filename without extension
  ///
  /// Get the [WidgetId] from [onConfigureWidget] callback.
  ///
  /// [textViews] is the id defined in layout `<TextView android:id="@+id/widget_title"`
  ///
  /// ```dart
  /// {
  ///   "widget_title": "TEXT TO DISPLAY",
  ///   "widget_subtitle": "TEXT TO DISPLAY"
  /// }
  /// ```
  ///
  /// accept optional [itemId] and [stringUid] which can be include
  /// in onClickWidget callback.
  ///
  Future<bool?> configureWidget({
    int? widgetId,
    String? widgetLayout,
    Map<String, String>? textViews = const {},
    String? payload,
    String? url,
    String? androidPackageName,
  }) async {
    return AppWidgetPlatform.instance.configureWidget(
      androidPackageName: androidPackageName ?? _androidPackageName,
      widgetId: widgetId,
      widgetLayout: widgetLayout,
      textViews: textViews,
      payload: payload,
      url: url,
    );
  }

  ///
  /// Get all widgetId associated with a AppWidgetProvider
  ///
  /// [androidProviderName] is the provider class name which also it's filename <br>
  /// eg: `AppWidgetExampleProvider`
  ///
  Future<List<int>?> getWidgetIds({
    required String androidProviderName,
    String? androidPackageName,
  }) {
    return AppWidgetPlatform.instance.getWidgetIds(
      androidPackageName: androidPackageName ?? _androidPackageName,
      androidProviderName: androidProviderName,
    );
  }

  /// Force reload all widgets
  ///
  /// This is a convenient method to force reload all widgets from dart side.
  ///
  /// This will trigger onUpdate method on android side.
  /// Use this if you handle widget update from `AppWidgetProvider` directly
  /// otherwise this method is useless.
  ///
  /// [androidProviderName] is the provider class name which also it's filename <br>
  /// eg: `AppWidgetExampleProvider`
  ///
  Future<bool?> reloadWidgets({
    String? androidProviderName,
    String? androidPackageName,
  }) async {
    return AppWidgetPlatform.instance.reloadWidgets(
      androidPackageName: androidPackageName ?? _androidPackageName,
      androidProviderName: androidProviderName,
    );
  }

  /// Update widget view manually
  ///
  /// [androidPackageName] should be the app package name.
  /// eg: com.example.myapp
  ///
  /// [widgetLayout] is the layout filename without extension
  ///
  /// Get the [WidgetId] from [onConfigureWidget] callback when the widget
  /// is created for the first time.
  ///
  /// [textViews] is the id defined in layout `<TextView android:id="@+id/widget_title"`
  ///
  /// ```dart
  /// {
  ///   "widget_title": "TEXT TO DISPLAY",
  ///   "widget_subtitle": "TEXT TO DISPLAY"
  /// }
  /// ```
  ///
  /// Accept optional [itemId] and [stringUid] which can be include
  /// in onClickWidget callback.
  ///
  Future<bool?> updateWidget({
    int? widgetId,
    String? widgetLayout,
    Map<String, String>? textViews = const {},
    String? payload,
    String? url,
    String? androidPackageName,
  }) async {
    return AppWidgetPlatform.instance.updateWidget(
      androidPackageName: androidPackageName ?? _androidPackageName,
      widgetId: widgetId,
      widgetLayout: widgetLayout,
      textViews: textViews,
      payload: payload,
      url: url,
    );
  }

  /// return [true] if a widget with given [widgetId] exist
  Future<bool?> widgetExist(int widgetId) async {
    return AppWidgetPlatform.instance.widgetExist(widgetId);
  }
}
