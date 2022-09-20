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
  late final TextEditingController _controller;
  int? _widgetId;

  @override
  void initState() {
    super.initState();
    _appWidgetPlugin = AppWidgetPlugin(
      // androidPackageName: 'tech.noxasch.app_widget_example',
      onConfigureWidget: onConfigureWidget,
      onClickWidget: onClickWidget,
    );
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextField(
                  decoration: const InputDecoration(label: Text('Widget Id')),
                  controller: _controller,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ConfigureButton(
                  widgetId: _widgetId, appWidgetPlugin: _appWidgetPlugin),
              const SizedBox(
                height: 10,
              ),
              WidgetExistButton(
                controller: _controller,
                appWidgetPlugin: _appWidgetPlugin,
              ),
              const SizedBox(
                height: 10,
              ),
              ReloadWidgetButton(appWidgetPlugin: _appWidgetPlugin),
              const SizedBox(
                height: 10,
              ),
              UpdateWidgetButton(
                  controller: _controller, appWidgetPlugin: _appWidgetPlugin),
              const SizedBox(
                height: 10,
              ),
              GetWidgetIdsButton(appWidgetPlugin: _appWidgetPlugin),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateWidgetButton extends StatelessWidget {
  const UpdateWidgetButton({
    Key? key,
    required TextEditingController controller,
    required AppWidgetPlugin appWidgetPlugin,
  })  : _controller = controller,
        _appWidgetPlugin = appWidgetPlugin,
        super(key: key);

  final TextEditingController _controller;
  final AppWidgetPlugin _appWidgetPlugin;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final messenger = ScaffoldMessenger.of(context);

        if (_controller.text.isNotEmpty) {
          // this means the app is started by the widget config event
          final widgetId = int.parse(_controller.text);

          // send configure
          await _appWidgetPlugin.updateWidget(
              widgetId: widgetId,
              widgetLayout: 'example_layout',
              textViews: {
                'widget_title': 'App Widget',
                'widget_message': 'Updated in flutter'
              });
        }
      },
      child: const Text('Update Widget'),
    );
  }
}

class GetWidgetIdsButton extends StatelessWidget {
  const GetWidgetIdsButton({
    Key? key,
    required AppWidgetPlugin appWidgetPlugin,
  })  : _appWidgetPlugin = appWidgetPlugin,
        super(key: key);

  final AppWidgetPlugin _appWidgetPlugin;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final messenger = ScaffoldMessenger.of(context);
        final widgetIds = await _appWidgetPlugin.getWidgetIds(
            androidProviderName: 'AppWidgetExampleProvider');
        messenger.showSnackBar(
          SnackBar(
            content: Text('widget ids: ${widgetIds ?? ""}'),
          ),
        );
      },
      child: const Text('Get WidgetIds'),
    );
  }
}

class ReloadWidgetButton extends StatelessWidget {
  const ReloadWidgetButton({
    Key? key,
    required AppWidgetPlugin appWidgetPlugin,
  })  : _appWidgetPlugin = appWidgetPlugin,
        super(key: key);

  final AppWidgetPlugin _appWidgetPlugin;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final messenger = ScaffoldMessenger.of(context);
        await _appWidgetPlugin.reloadWidgets(
            androidProviderName: 'AppWidgetExampleProvider');
        messenger.showSnackBar(
          const SnackBar(
            content:
                Text('Reload broadcast has been sent check Android debug log'),
          ),
        );
      },
      child: const Text('Reload Widgets'),
    );
  }
}

class WidgetExistButton extends StatelessWidget {
  const WidgetExistButton({
    Key? key,
    required TextEditingController controller,
    required AppWidgetPlugin appWidgetPlugin,
  })  : _controller = controller,
        _appWidgetPlugin = appWidgetPlugin,
        super(key: key);

  final TextEditingController _controller;
  final AppWidgetPlugin _appWidgetPlugin;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          if (_controller.text.isNotEmpty) {
            final messenger = ScaffoldMessenger.of(context);

            final widgetId = int.parse(_controller.text);
            final exist = (await _appWidgetPlugin.widgetExist(widgetId))!;
            if (exist) {
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('This widget exist.'),
                ),
              );
            } else {
              messenger.showSnackBar(
                SnackBar(
                  content: Text('Widget with id $widgetId does not exist.'),
                ),
              );
            }
          }
        },
        child: const Text('check if Widget Exist'));
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
                widgetId: _widgetId!,
                widgetLayout: 'example_layout',
                textViews: {
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
