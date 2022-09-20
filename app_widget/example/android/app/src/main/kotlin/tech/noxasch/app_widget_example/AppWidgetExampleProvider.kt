package tech.noxasch.app_widget_example

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.util.Log
import android.widget.RemoteViews
import androidx.core.content.ContextCompat.startActivity
import androidx.core.view.accessibility.AccessibilityEventCompat.setAction
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import tech.noxasch.app_widget.AppWidgetPlugin

class AppWidgetExampleProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context?,
        appWidgetManager: AppWidgetManager?,
        appWidgetIds: IntArray?
    ) {
        super.onUpdate(context, appWidgetManager, appWidgetIds)
        Log.d("APP_WIDGET_PLUGIN", "ON_UPDATE")
        if (appWidgetIds != null) {
            for (widgetId in appWidgetIds) {
                Log.d("APP_WIDGET_PLUGIN", "WIDGET_ID: $widgetId")
            }
        }

        // check if widgetId store sharedPreferences
        // fetch data from sharedPreferences
        // then update
//        for (widgetId in appWidgetIds!!) {
//            val remoteViews = RemoteViews(context!!.packageName, R.layout.example_layout).apply() {
//                setTextViewText(R.id.widget_title, "Widget Title")
//                setTextViewText(R.id.widget_message, "This is my message")
//            }
//
//            appWidgetManager!!.partiallyUpdateAppWidget(widgetId, remoteViews)
//        }
    }
}
