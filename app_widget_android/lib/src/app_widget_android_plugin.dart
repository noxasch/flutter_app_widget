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
    void Function(int widgetId)? onConfigureWidget,
    void Function(Map<String, dynamic> payload)? onClickWidget,
  })  : _onConfigureWidget = onConfigureWidget,
        _onClickWidget = onClickWidget {
    _methodChannel.setMethodCallHandler(handleMethod);
  }

  final void Function(int widgetId)? _onConfigureWidget;
  final void Function(Map<String, dynamic> payload)? _onClickWidget;

  Future<dynamic> handleMethod(MethodCall call) async {
    print('NOXASCH_PLUGIN_DART: methodCall ${call.method}');
    switch (call.method) {
      case onConfigureWidgetCallback:
        final widgetId = call.arguments['widgetId'] as int;
        return _onConfigureWidget?.call(widgetId);
      case onClickWidgetCallback:
        final payload = {
          'widgetId': call.arguments['widgetId'],
          'itemId': call.arguments['widgetId'],
          'stringUid': call.arguments['widgetId'],
        };
        return _onClickWidget?.call(payload);
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
  Future<bool?> widgetExist(int widgetId) {
    return _methodChannel
        .invokeMethod<bool>('widgetExist', {'widgetId': widgetId});
  }

  @override
  Future<bool?> configureWidget({
    String? androidAppName,
    int? widgetId,
    String? widgetLayout,
    Map<String, String>? textViewIdValueMap,
    int? itemId,
    String? stringUid,
  }) {
    return _methodChannel.invokeMethod<bool>('configureWidget', {
      'androidAppName': androidAppName,
      'widgetLayout': widgetLayout,
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
