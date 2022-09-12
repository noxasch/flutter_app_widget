import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'app_widget_method_channel.dart';

abstract class AppWidgetPlatform extends PlatformInterface {
  /// Constructs a AppWidgetPlatform.
  AppWidgetPlatform() : super(token: _token);

  static final Object _token = Object();

  static AppWidgetPlatform _instance = MethodChannelAppWidget();

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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
