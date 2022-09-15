import 'package:app_widget/app_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// there is no way to test callback as it need to interact with actual widgets
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('configureWidget', (tester) async {
    final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin();

    expect(
        appWidgetPlugin.configureWidget(
          androidAppName: 'tech.noxasch.app_widget_example',
          widgetId: 1,
          widgetLayout: 'example_layout',
          itemId: 1,
          stringUid: 'uid',
          textViewIdValueMap: {'widget_title': 'my title'},
        ),
        completion(true));
  });

  testWidgets('Can check if widget exist', (tester) async {
    final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin();
    final res = await appWidgetPlugin.widgetExist(12);
    expect(res, isFalse);
  });

  testWidgets('Can send cancel signal', (tester) async {
    final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin();
    final res = await appWidgetPlugin.cancelConfigureWidget();
    expect(res, isTrue);
  });

  testWidgets('reloadWidget throw expected error', (tester) async {
    final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin();

    expect(
        () => appWidgetPlugin.reloadWidgets(
            androidAppName: 'tech.noxasch.app_widget_example',
            androidProviderName: 'AppWidgetExampleProvider'),
        throwsA(isA<PlatformException>()
            .having((e) => e.code == '-2', '', isTrue)));
  });
}
