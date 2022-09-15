package tech.noxasch.app_widget

import android.app.Activity
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import android.widget.RemoteViews
import androidx.annotation.Keep
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

@Keep
open class AppWidgetBroadcastReceiver : AppWidgetProvider() {
    override fun onEnabled(context: Context?) {
        super.onEnabled(context)
    }

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
            val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, AppWidgetPlugin.CHANNEL)
            channel.invokeMethod(AppWidgetPlugin.ON_UPDATE_WIDGETS_CALLBACK, appWidgetIds)
            Log.i("NOXASCH_RECEIVER",channel.toString())
        }



//        val binding = FlutterPlugin

//        val engine = FlutterEngine(context!!)
//        engine.

//        if (appWidgetIds != null) {
//            .invokeMethod(AppWidgetPlugin.ON_UPDATE_WIDGET_CALLBACK, appWidgetIds)
//        }
//        if (appWidgetIds != null) {
//            for (widgetId in appWidgetIds) {
//                // TODO: communicate with workmanager
//                Log.i("NOXASCH_PLUGIN_PROVIDER", "widgetId: $widgetId")
//
//            }
//        }
    }

    override fun onDeleted(context: Context?, appWidgetIds: IntArray?) {
        super.onDeleted(context, appWidgetIds)
        Log.i("NOXASCH_PLUGIN", "ON DELETE")
        Log.i("NOXASCH_PLUGIN", "CONTEXT ${context != null}")
//        if (appWidgetIds != null) {
//            AppWidgetPlugin.channel.invokeMethod(AppWidgetPlugin.ON_DELETED_WIDGET_CALLBACK, appWidgetIds)
//        }
    }

//    private fun configureWidgetView(
//        context: Context,
//        androidAppName : String,
//        views : RemoteViews,
//        widgetId : Int,
//        widgetLayoutId : Int,
//        pendingIntent : PendingIntent,
//        appWidgetManager: AppWidgetManager,
//        textViewIdValueMap : Map<String, String>?
//    ) {
////    val views : RemoteViews = RemoteViews(androidAppName, widgetLayoutId)
//        views.apply {
//            setOnClickPendingIntent(widgetLayoutId, pendingIntent)
//
//            if (textViewIdValueMap != null) {
//                for ((key, value) in textViewIdValueMap) {
//                    val textViewId: Int =
//                        context.resources.getIdentifier(key, "id", androidAppName)
//                    if (textViewId == 0) throw Exception("Id $key does not exist!")
//                    setTextViewText(textViewId, value)
//                }
//            }
//        }
//
//        appWidgetManager.updateAppWidget(widgetId, views)
//    }
//
//    private fun createPendingIntent(
//        context: Context,
//        activityClass: Class<*>,
//        widgetId : Int,
//        itemId : Int?,
//    ) : PendingIntent {
//        val intent = Intent(context, activityClass)
//        var pendingIntentFlag = PendingIntent.FLAG_UPDATE_CURRENT
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//            pendingIntentFlag = pendingIntentFlag or PendingIntent.FLAG_IMMUTABLE
//        }
//
//        return PendingIntent.getActivity(context, itemId ?: widgetId, intent, pendingIntentFlag)
//    }
}