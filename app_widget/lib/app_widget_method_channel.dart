import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'app_widget_platform_interface.dart';

/// An implementation of [AppWidgetPlatform] that uses method channels.
class MethodChannelAppWidget extends AppWidgetPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('app_widget');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
