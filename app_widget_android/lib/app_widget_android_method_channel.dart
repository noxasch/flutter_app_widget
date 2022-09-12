import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'app_widget_android_platform_interface.dart';

/// An implementation of [AppWidgetAndroidPlatform] that uses method channels.
class MethodChannelAppWidgetAndroid extends AppWidgetAndroidPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('app_widget_android');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
