import 'package:app_widget/app_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// there is no way to test callback as it need to interact with actual widgets
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('with androidPackageName', () {
    final AppWidgetPlugin appWidgetPlugin = AppWidgetPlugin(
      androidPackageName: 'tech.noxasch.app_widget_example',
    );

    testWidgets('configureWidget', (tester) async {
      final res = await appWidgetPlugin.configureWidget(
        androidPackageName: 'tech.noxasch.diff_name',
        widgetId: 1,
        layoutId: 1,
        payload: '{"itemId": 1, "stringUid": "uid"}',
        url: 'https://google.come',
      );
      expect(res, isTrue);
    });

    testWidgets('cancelConfigureWidget', (tester) async {
      final res = await appWidgetPlugin.cancelConfigureWidget();

      expect(res, isTrue);
    });

    testWidgets('updateWidget', (tester) async {
      final res = await appWidgetPlugin.updateWidget(
        androidPackageName: 'tech.noxasch.diff_name',
        widgetId: 1,
        layoutId: 1,
        payload: '{"itemId": 1, "stringUid": "uid"}',
        url: 'https://google.come',
        textViews: {'widget_title': 'my title'},
      );

      expect(res, isTrue);
    });

    testWidgets('getWidgetIds', (tester) async {
      final res = await appWidgetPlugin.getWidgetIds(
        androidPackageName: 'tech.noxasch.diff_name',
        androidProviderName: 'AppWidgetExampleDiffProvider',
      );

      expect(res, []);
    });

    testWidgets('reloadWidgets', (tester) async {
      final res = await appWidgetPlugin.reloadWidgets(
        androidPackageName: 'tech.noxasch.diff_name',
        androidProviderName: 'AppWidgetExampleDiffProvider',
      );

      expect(res, isTrue);
    });

    testWidgets('widgetExist', (tester) async {
      final res = await appWidgetPlugin.widgetExist(12);

      expect(res, isFalse);
    });
  });
}
