import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class AppWidgetPlatform extends PlatformInterface {
  /// Constructs a AppWidgetPlatform.
  AppWidgetPlatform() : super(token: _token);

  static final Object _token = Object();

  // static late AppWidgetPlatform _instance = MethodChannelAppWidget();
  // static AppWidgetPlatform _instance = MethodChannelAppWidget();
  static late AppWidgetPlatform _instance;

  /// The default instance of [AppWidgetPlatform] to use.
  ///
  /// Defaults to [MethodChannelAppWidget].
  static AppWidgetPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AppWidgetPlatform] when
  /// they register themselves.
  static set instance(AppWidgetPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  static const channel = 'tech.noxasch.flutter/app_widget';

  Future<bool?> cancelConfigureWidget() {
    throw UnimplementedError();
  }

  // the params are not require in base interface as different platform will require differet parameters
  // we handle this in platform specific and plugin interface
  Future<bool?> configureWidget({
    String? androidAppName,
    int? widgetId,
    String? widgetLayout,
    Map<String, String>? textViewIdValueMap,
    int? itemId,
    String? stringUid,
  }) async {
    throw UnimplementedError();
  }

  Future<bool?> reloadWidgets({
    String? androidAppName,
    String? androidProviderName,
  }) async {
    throw UnimplementedError();
  }

  Future<bool?> updateWidget({
    String? androidAppName,
    int? widgetId,
    String? widgetLayout,
    Map<String, String>? textViewIdValueMap,
    int? itemId,
    String? stringUid,
  }) async {
    throw UnimplementedError();
  }

  Future<List<int>?> getWidgetIds({String? androidProviderName}) async {
    throw UnimplementedError();
  }

  Future<bool?> widgetExist(int widgetId) async {
    throw UnimplementedError();
  }
}
