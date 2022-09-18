import 'package:flutter/material.dart';

import 'package:app_widget/app_widget.dart';

void onClickWidget(Map<String, dynamic> payload) {
  print('onClick Widget: $payload');
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

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
    setState(() => _widgetId = widgetId);
    // do something
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AppWidgetPlugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConfigureButton(
                  widgetId: _widgetId, appWidgetPlugin: _appWidgetPlugin),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            label: const Text('Update'),
            onPressed: () async {
              if (_widgetId != null) {
                // this means the app is started by the widget config event

                // send configure
                await _appWidgetPlugin.updateWidget(
                    androidPackageName: 'tech.noxasch.app_widget_example',
                    widgetId: _widgetId!,
                    widgetLayout: 'example_layout',
                    textViewIdValueMap: {
                      'widget_title': 'App Widget',
                      'widget_message': 'Updated in flutter'
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

class ConfigureButton extends StatelessWidget {
  const ConfigureButton({
    Key? key,
    required int? widgetId,
    required AppWidgetPlugin appWidgetPlugin,
  })  : _widgetId = widgetId,
        _appWidgetPlugin = appWidgetPlugin,
        super(key: key);

  final int? _widgetId;
  final AppWidgetPlugin _appWidgetPlugin;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          if (_widgetId != null) {
            // this means the app is started by the widget config event
            final messenger = ScaffoldMessenger.of(context);

            // send configure
            await _appWidgetPlugin.configureWidget(
                androidPackageName: 'tech.noxasch.app_widget_example',
                widgetId: _widgetId!,
                widgetLayout: 'example_layout',
                textViewIdValueMap: {
                  'widget_title': 'App Widget',
                  'widget_message': 'Configured in flutter'
                });
            messenger.showSnackBar(
                const SnackBar(content: Text('Widget has been configured!')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text('Opps, no widget id from WIDGET_CONFIGURE event')));
          }
        },
        child: const Text('Configure Widget'));
  }
}
