package tech.noxasch.app_widget_example

import android.appwidget.AppWidgetManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import tech.noxasch.app_widget.AppWidgetPlugin

// this need to be implemented manually
class MainActivity: FlutterActivity() {
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    if (intent.action == AppWidgetManager.ACTION_APPWIDGET_CONFIGURE) {
      AppWidgetPlugin.Companion.handleConfigureAction(context, intent)
    }
  }
}
