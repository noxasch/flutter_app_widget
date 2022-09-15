package tech.noxasch.app_widget_example

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.core.content.ContextCompat.startActivity
import androidx.core.view.accessibility.AccessibilityEventCompat.setAction
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import tech.noxasch.app_widget.AppWidgetBroadcastReceiver
import tech.noxasch.app_widget.AppWidgetPlugin

class AppWidgetExampleProvider : AppWidgetBroadcastReceiver() {
    override fun onUpdate(
        context: Context?,
        appWidgetManager: AppWidgetManager?,
        appWidgetIds: IntArray?
    ) {
        super.onUpdate(context, appWidgetManager, appWidgetIds)
        Log.i("NOXASCH_PLUGIN", "CONTEXT ${context != null}")
        Log.i("NOXASCH_PLUGIN", "ON UPDATE")

        if (context != null && appWidgetIds != null) {
            Log.i("NOXASCH_RECEIVER", "HAVE")
            val flutterEngine = FlutterEngine(context)

//            val channel = MethodChannel(, AppWidgetPlugin.CHANNEL)
//            channel.invokeMethod(AppWidgetPlugin.ON_UPDATE_WIDGETS_CALLBACK, appWidgetIds)
//            Log.i("NOXASCH_RECEIVER",channel.toString())
//            val updateIntent = Intent()
//            context.
//            updateIntent.action = (AppWidgetPlugin.UPDATE_WIDGETS_ACTION)
//            context.applicationContext.startActivity(updateIntent)
        }
    }

}