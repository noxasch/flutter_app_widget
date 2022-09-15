import 'package:flutter/material.dart';

import 'package:app_widget/app_widget.dart';
import 'package:flutter/services.dart';

void onClickWidget(Map<String, dynamic> payload) {
  print("NOXASCH_EXAMPLE: onClickWidget");
}

void onUpdateWidgets(List<int> widgetIds) {
  print("NOXASCH_EXAMPLE: onUpdateWidgets");
}

void onDeletedWidgets(List<int> widgetIds) {
  print("NOXASCH_EXAMPLE: onDeletedWidgets");
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

// void onConfigureWidget(int widgetId) {
//   // skip if zero - seems like a bug whenever flutter restart
//   print('NOXASCH: DARTTT $widgetId');
//   // 1. open deeplink with params
//   // launchUrl(Uri.parse('https://www.google.com'));
// }

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  late final AppWidgetPlugin _appWidgetPlugin;
  int? _widgetId;

  @override
  void initState() {
    super.initState();
    _appWidgetPlugin = AppWidgetPlugin(
      onConfigureWidget: onConfigureWidget,
      onClickWidget: onClickWidget,
    );
    initPlatformState();
  }

  void onConfigureWidget(int widgetId) {
    _widgetId = widgetId;
    // skip if zero - seems like a bug whenever flutter restart
    print('NOXASCH_EXAMPLE: onConfigureWidget $widgetId');
    // 1. open deeplink with params
    // launchUrl(Uri.parse('https://www.google.com'));
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _appWidgetPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AppWidgetPlugin example app'),
        ),
        body: Center(
          child: Text('Running on $_platformVersion'),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () async {
          // await _appWidgetPlugin.cancelConfigureWidget();
          if (_widgetId != null) {
            await _appWidgetPlugin.configureWidget(
                androidAppName: 'tech.noxasch.app_widget_example',
                widgetId: _widgetId!,
                widgetLayout: 'example_layout',
                widgetContainerName: 'widget_container',
                textViewIdValueMap: {
                  'widget_title': 'MY WIDGET',
                  'widget_message': 'This is my widget message'
                });
          } else {
            await _appWidgetPlugin.reloadWidgets(
                androidAppName:
                    'tech.noxasch.app_widget_example.AppWidgetExampleProvider',
                androidProviderName:
                    'tech.noxasch.app_widget.AppWidgetBroadcastReceiver');
          }
        }),
      ),
    );
  }
}
