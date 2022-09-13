import 'package:app_widget_android/src/app_widget_android_platform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const MethodChannel _methodChannel =
    MethodChannel('tech.noxasch/app_widget_android');

class AppWidgetAndroidPlugin extends AppWidgetAndroid {
  AppWidgetAndroidPlugin({this.onConfigureWidget}) {
    _methodChannel.setMethodCallHandler(handleMethod);
  }

  final VoidCallback? onConfigureWidget;

  Future<void> handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'configureWidget':
        onConfigureWidget?.call();
        break;
      case 'onUpdateWidget':
        break;
      case 'onClickWidget':
        break;
      default:
        throw UnimplementedError('Method ${call.method} is not implemented!');
    }
  }
}
