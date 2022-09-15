package tech.noxasch.app_widget_example

import android.appwidget.AppWidgetManager
import android.content.Intent
import android.os.Bundle
import android.util.Log
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel
import tech.noxasch.app_widget.AppWidgetPlugin

// this need to be implemented manually
class MainActivity: FlutterActivity() {
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    val isAppWidgetConfigureAction = intent.action == AppWidgetManager.ACTION_APPWIDGET_CONFIGURE

    if (isAppWidgetConfigureAction) {
      handleConfigureAction()
    }

  }


  private fun handleConfigureAction() {
    val extras = intent.extras
    val widgetId: Int = extras?.getInt(AppWidgetManager.EXTRA_APPWIDGET_ID) ?: return
    if (widgetId == 0) return

    val configIntent = intent.setAction(AppWidgetPlugin.CONFIGURE_WIDGET_ACTION)
    configIntent.putExtra("widgetId", widgetId)
    startActivity(configIntent)
  }
}
