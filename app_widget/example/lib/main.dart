import 'package:flutter/material.dart';

import 'package:app_widget/app_widget.dart';

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
  late final AppWidgetPlugin _appWidgetPlugin;
  int? _widgetId;

  @override
  void initState() {
    super.initState();
    _appWidgetPlugin = AppWidgetPlugin(
      onConfigureWidget: onConfigureWidget,
      onClickWidget: onClickWidget,
    );
  }

  void onConfigureWidget(int widgetId) {
    _widgetId = widgetId;
    // skip if zero - seems like a bug whenever flutter restart
    print('NOXASCH_EXAMPLE: onConfigureWidget $widgetId');
    // 1. open deeplink with params
    // launchUrl(Uri.parse('https://www.google.com'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AppWidgetPlugin example app'),
        ),
        body: const Center(
          child: Text('AppWidgetPlugin test'),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () async {
          // await _appWidgetPlugin.cancelConfigureWidget();
          if (_widgetId != null) {
            await _appWidgetPlugin.configureWidget(
                widgetId: _widgetId!,
                widgetLayout: 'example_layout',
                textViewIdValueMap: {
                  'widget_title': 'MY WIDGET',
                  'widget_message': 'This is my widget message'
                });
          } else {
            await _appWidgetPlugin.reloadWidgets(
                androidProviderName:
                    'tech.noxasch.app_widget.AppWidgetBroadcastReceiver');
          }
        }),
      ),
    );
  }
}
