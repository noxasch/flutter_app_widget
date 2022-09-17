import 'package:app_widget/app_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// there is no way to test callback as it need to interact with actual widgets
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('configureWidget', (tester) async {
    final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin();

    final res = await appWidgetPlugin.configureWidget(
      androidPackageName: 'tech.noxasch.app_widget_example',
      widgetId: 1,
      widgetLayout: 'example_layout',
      itemId: 1,
      stringUid: 'uid',
      textViewIdValueMap: {'widget_title': 'my title'},
    );
    expect(res, isTrue);
  });

  testWidgets('cancelConfigureWidget', (tester) async {
    final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin();

    final res = await appWidgetPlugin.cancelConfigureWidget();

    expect(res, isTrue);
  });

  testWidgets('getWidgetIds', (tester) async {
    final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin();

    final res = await appWidgetPlugin.getWidgetIds(
        androidProviderName: 'AppWidgetExampleProvider');

    expect(res, []);
  });

  testWidgets('updateWidget', (tester) async {
    final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin();

    final res = await appWidgetPlugin.updateWidget(
      androidPackageName: 'tech.noxasch.app_widget_example',
      widgetId: 1,
      widgetLayout: 'example_layout',
      itemId: 1,
      stringUid: 'uid',
      textViewIdValueMap: {'widget_title': 'my title'},
    );

    expect(res, isTrue);
  });

  testWidgets('reloadWidgets throw expected error', (tester) async {
    final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin();

    final res = await appWidgetPlugin.reloadWidgets(
        androidProviderName: 'AppWidgetExampleProvider');

    expect(res, isTrue);
  });

  testWidgets('widgetExist', (tester) async {
    final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin();

    final res = await appWidgetPlugin.widgetExist(12);

    expect(res, isFalse);
  });
}
