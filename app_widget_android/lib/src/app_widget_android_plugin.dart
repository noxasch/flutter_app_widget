import 'package:app_widget_android/src/app_widget_android_platform.dart';
import 'package:app_widget_platform_interface/app_widget_platform_interface.dart';
import 'package:flutter/services.dart';

const onConfigureWidgetCallback = 'onConfigureWidget';
const onClickWidgetCallback = 'onClickWidget';
const onUpdateWidgetsCallback = 'onUpdateWidgets';
const onDeletedWidgetsCallback = 'onDeletedWidgets';

const MethodChannel _methodChannel = MethodChannel(AppWidgetPlatform.channel);

class AppWidgetAndroidPlugin extends AppWidgetAndroid {
  AppWidgetAndroidPlugin({
    this.onConfigureWidget,
    this.onUpdateWidgets,
    this.onDeletedWidgets,
    this.onClickWidget,
  }) {
    print('initialize AppWidgetAndroidPlugin');
    _methodChannel.setMethodCallHandler(handleMethod);
  }

  final void Function(int widgetId)? onConfigureWidget;
  final void Function(List<int> widgetIds)? onUpdateWidgets;
  final void Function(List<int> widgetIds)? onDeletedWidgets;
  final void Function(Map<String, dynamic> payload)? onClickWidget;

  Future<dynamic> handleMethod(MethodCall call) async {
    switch (call.method) {
      case onConfigureWidgetCallback:
        final widgetId = call.arguments['widgetId'] as int;
        return onConfigureWidget?.call(widgetId);
      case onUpdateWidgetsCallback:
        final widgetIds = call.arguments['widgetIds'] as List<int>;
        return onUpdateWidgets?.call(widgetIds);
      case onDeletedWidgetsCallback:
        final widgetIds = call.arguments['widgetIds'] as List<int>;
        return onDeletedWidgets?.call(widgetIds);
      case onClickWidgetCallback:
        final payload = {
          'widgetId': call.arguments['widgetId'],
          'itemId': call.arguments['widgetId'],
          'stringUid': call.arguments['widgetId'],
        };
        return onClickWidget?.call(payload);
      default:
        throw UnimplementedError('Method ${call.method} is not implemented!');
    }
  }

  @override
  Future<String?> getPlatformVersion() {
    return _methodChannel.invokeMethod<String>('getPlatformVersion');
  }

  @override
  Future<bool?> reloadWidgets({
    String? androidAppName,
    String? androidProviderName,
  }) {
    return _methodChannel.invokeMethod<bool>('reloadWidgets', {
      'androidAppName': androidAppName,
      'androidProviderName': androidProviderName
    });
  }

  @override
  Future<bool?> configureWidget({
    String? androidAppName,
    int? widgetId,
    String? widgetLayout,
    String? widgetContainerName,
    Map<String, String>? textViewIdValueMap,
    int? itemId,
    String? stringUid,
  }) {
    return _methodChannel.invokeMethod<bool>('configureWidget', {
      'androidAppName': androidAppName,
      'widgetLayout': widgetLayout,
      'widgetContainerName': widgetContainerName,
      'widgetId': widgetId,
      'textViewIdValueMap': textViewIdValueMap,
      'itemId': itemId,
      'stringUid': stringUid,
    });
  }

  Future<bool?> cancelConfigureWidget() {
    return _methodChannel.invokeMethod<bool>('cancelConfigureWidget');
  }
}
