import 'package:app_widget/app_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// there is no way to test callback as it need to interact with actual widgets
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('configureWidget', (tester) async {
    final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin(
      androidPackageName: 'tech.noxasch.app_widget_example',
    );

    final res = await appWidgetPlugin.configureWidget(
      widgetId: 1,
      widgetLayout: 'example_layout',
      payload: '{"itemId": 1, "stringUid": "uid"}',
      url: 'https://google.come',
    );
    expect(res, isTrue);
  });

  testWidgets('configureWidget without packageName', (tester) async {
    final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin(
      androidPackageName: 'tech.noxasch.app_widget_example',
    );

    final res = await appWidgetPlugin.configureWidget(
      widgetId: 1,
      widgetLayout: 'example_layout',
      payload: '{"itemId": 1, "stringUid": "uid"}',
      url: 'https://google.come',
    );
    expect(res, isTrue);
  });

  testWidgets('cancelConfigureWidget', (tester) async {
    final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin(
      androidPackageName: 'tech.noxasch.app_widget_example',
    );

    final res = await appWidgetPlugin.cancelConfigureWidget();

    expect(res, isTrue);
  });

  testWidgets('getWidgetIds', (tester) async {
    final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin(
      androidPackageName: 'tech.noxasch.app_widget_example',
    );

    final res = await appWidgetPlugin.getWidgetIds(
        androidProviderName: 'AppWidgetExampleProvider');

    expect(res, []);
  });

  testWidgets('getWidgetIds without packageName', (tester) async {
    final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin();

    final res = await appWidgetPlugin.getWidgetIds(
        androidProviderName: 'AppWidgetExampleProvider');

    expect(res, []);
  });

  testWidgets('reloadWidgets', (tester) async {
    final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin();

    final res = await appWidgetPlugin.reloadWidgets(
        androidProviderName: 'AppWidgetExampleProvider');

    expect(res, isTrue);
  });

  testWidgets('updateWidget', (tester) async {
    final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin(
      androidPackageName: 'tech.noxasch.app_widget_example',
    );

    final res = await appWidgetPlugin.updateWidget(
      widgetId: 1,
      widgetLayout: 'example_layout',
      payload: '{"itemId": 1, "stringUid": "uid"}',
      url: 'https://google.come',
      textViews: {'widget_title': 'my title'},
    );

    expect(res, isTrue);
  });

  testWidgets('updateWidget without packageName', (tester) async {
    final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin();

    final res = await appWidgetPlugin.updateWidget(
      widgetId: 1,
      widgetLayout: 'example_layout',
      payload: '{"itemId": 1, "stringUid": "uid"}',
      url: 'https://google.come',
      textViews: {'widget_title': 'my title'},
    );

    expect(res, isTrue);
  });

  testWidgets('widgetExist', (tester) async {
    final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin(
      androidPackageName: 'tech.noxasch.app_widget_example',
    );

    final res = await appWidgetPlugin.widgetExist(12);

    expect(res, isFalse);
  });
}
