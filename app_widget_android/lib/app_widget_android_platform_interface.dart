import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'app_widget_android_method_channel.dart';

abstract class AppWidgetAndroidPlatform extends PlatformInterface {
  /// Constructs a AppWidgetAndroidPlatform.
  AppWidgetAndroidPlatform() : super(token: _token);

  static final Object _token = Object();

  static AppWidgetAndroidPlatform _instance = MethodChannelAppWidgetAndroid();

  /// The default instance of [AppWidgetAndroidPlatform] to use.
  ///
  /// Defaults to [MethodChannelAppWidgetAndroid].
  static AppWidgetAndroidPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AppWidgetAndroidPlatform] when
  /// they register themselves.
  static set instance(AppWidgetAndroidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
