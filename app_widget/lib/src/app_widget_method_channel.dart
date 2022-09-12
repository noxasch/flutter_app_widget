import 'package:app_widget_platform_interface/app_widget_platform_interface.dart';
import 'package:flutter/services.dart';

const MethodChannel _methodChannel =
    MethodChannel('noxasch.tech/flutter/app_widget');

/// An implementation of [AppWidgetPlatform] that uses method channels.
class MethodChannelAppWidget extends AppWidgetPlatform {
  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await _methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
