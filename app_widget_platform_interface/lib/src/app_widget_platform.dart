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

  Future<String?> getPlatformVersion() async {
    throw UnimplementedError();
  }

  //
  Future configureWidget() async {
    throw UnimplementedError();
  }

  Future updateWidget() async {
    throw UnimplementedError();
  }
}
