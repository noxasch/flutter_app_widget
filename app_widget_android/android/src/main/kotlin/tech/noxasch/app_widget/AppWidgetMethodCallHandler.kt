package tech.noxasch.app_widget

import android.app.Activity
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.widget.RemoteViews
import androidx.annotation.NonNull
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AppWidgetMethodCallHandler(private val context: Context, )
    : MethodChannel.MethodCallHandler {

    private var channel: MethodChannel? = null
    private var activity: Activity? = null

    fun open(binaryMessenger: BinaryMessenger) {
        channel = MethodChannel(binaryMessenger, AppWidgetPlugin.CHANNEL)
        channel!!.setMethodCallHandler(this)
    }

    fun setActivity(_activity: Activity?) {
        activity = _activity
    }

    fun close() {
        if (channel == null) return

        channel!!.setMethodCallHandler(null)
        channel = null
        activity = null
    }

    fun handleConfigureIntent(intent: Intent): Boolean {
        val widgetId = intent.extras!!.getInt("widgetId")
        channel!!.invokeMethod(AppWidgetPlugin.ON_CONFIGURE_WIDGET_CALLBACK, mapOf("widgetId" to widgetId))
        return true
    }


    fun handleClickIntent(intent: Intent): Boolean {
        val payload = intent.extras?.getString(AppWidgetPlugin.EXTRA_PAYLOAD)

        channel!!.invokeMethod(AppWidgetPlugin.ON_ClICK_WIDGET_CALLBACK,  mapOf(
            "payload" to payload
        ))
        return true
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "cancelConfigureWidget" -> cancelConfigureWidget(result)
            "configureWidget" -> configureWidget(call, result)
            "getWidgetIds" -> getWidgetIds(call, result)
            "reloadWidgets" -> reloadWidgets(call, result)
            "updateWidget" -> updateWidget(call, result)
            "widgetExist" -> widgetExist(call, result)
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun getWidgetIds(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        val androidPackageName = call.argument<String>("androidPackageName")
            ?: context.packageName
        val widgetProviderName = call.argument<String>("androidProviderName") ?: return result.error(
            "-1",
            "widgetProviderName is required!",
            null
        )

        return try {
            val widgetProviderClass = Class.forName("$androidPackageName.$widgetProviderName")
            val widgetProvider = ComponentName(context, widgetProviderClass)
            val widgetManager = AppWidgetManager.getInstance(context)
            val widgetIds = widgetManager.getAppWidgetIds(widgetProvider)

            result.success(widgetIds)
        } catch (exception: Exception) {
            result.error("-2", exception.message, exception)
        }
    }

    private fun cancelConfigureWidget(@NonNull result: MethodChannel.Result) {
        return try {
            activity!!.setResult(Activity.RESULT_CANCELED)
            result.success(true)
        } catch (exception: Exception) {
            result.error("-2", exception.message, exception)
        }
    }



    /// This should be called when configuring individual widgets
    private fun configureWidget(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        return try {
            if (activity == null) return result.error("-2", "Not attached to any activity!", null)

            val androidPackageName = call.argument<String>("androidPackageName")
                ?:  context.packageName
            val widgetId = call.argument<Int>("widgetId")
                ?: return result.error("-1", "widgetId is required!", null)
            val widgetLayout = call.argument<String>("widgetLayout")
                ?: return result.error("-1", "widgetLayout is required!", null)

            val widgetLayoutId: Int = context.resources.getIdentifier(widgetLayout, "layout", context.packageName)
            val payload = call.argument<String>("payload")
            val url = call.argument<String>("url")
            val activityClass = Class.forName("${context.packageName}.MainActivity")
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val pendingIntent = createPendingClickIntent(activityClass, widgetId, payload, url)
            val textViewsMap = call.argument<Map<String, String>>("textViews")

            if (textViewsMap != null) {
                val views : RemoteViews = RemoteViews(context.packageName, widgetLayoutId).apply {
                    for ((key, value) in textViewsMap) {
                        val textViewId: Int =
                            context.resources.getIdentifier(key, "id", context.packageName)
                        if (textViewId == 0) throw Exception("Id $key does not exist!")
                        setTextViewText(textViewId, value)
                        setOnClickPendingIntent(textViewId, pendingIntent)
                    }
                }
                appWidgetManager.updateAppWidget(widgetId, views)
            }

            // This is important to confirm the widget
            // otherwise it's considered cancelled and widget will be removed
            val resultValue = Intent().putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
            activity!!.setResult(Activity.RESULT_OK, resultValue)
            activity!!.finish()
            result.success(true)
        } catch (exception: Exception) {
            result.error("-2", exception.message, exception)
        }
    }

    private fun widgetExist(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        val widgetId = call.argument<Int>("widgetId") ?: return result.success(false)
        return try {
            val widgetManager = AppWidgetManager.getInstance(context)
            widgetManager.getAppWidgetInfo(widgetId) ?: return result.success(false)

            result.success(true)
        } catch (exception: Exception) {
            result.error("-2", exception.message, exception)
        }
    }

    // This should only be called after the widget has been configure for the first time
    private fun updateWidget(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        return try {
            val androidPackageName = call.argument<String>("androidPackageName")
                ?: context.packageName
            val widgetId = call.argument<Int>("widgetId")
                ?: return result.error("-1", "widgetId is required!", null)
            val widgetLayout = call.argument<String>("widgetLayout")
                ?: return result.error("-1", "widgetLayout is required!", null)

            val widgetLayoutId: Int =
                context.resources.getIdentifier(widgetLayout, "layout", context.packageName)
            val payload = call.argument<String>("payload")
            val url = call.argument<String>("url")
            val activityClass = Class.forName("${context.packageName}.MainActivity")
            val appWidgetManager = AppWidgetManager.getInstance(context)
            val pendingIntent = createPendingClickIntent(activityClass, widgetId, payload, url)
            val textViewsMap = call.argument<Map<String, String>>("textViews")

            if (textViewsMap != null) {
                val views = RemoteViews(context.packageName, widgetLayoutId)

                for ((key, value) in textViewsMap) {
                    val textViewId: Int =
                        context.resources.getIdentifier(key, "id", context.packageName)
                    if (textViewId == 0) throw Exception("Id $key does not exist!")

                    // only work if widget is blank - so we have to clear it first
                    views.setTextViewText(textViewId, "")
                    views.setTextViewText(textViewId, value)
                    views.setOnClickPendingIntent(textViewId, pendingIntent)
                }
                appWidgetManager.partiallyUpdateAppWidget(widgetId, views)
            }

            result.success(true)
        } catch (exception: Exception) {
            result.error("-2", exception.message, exception)
        }
    }

    /// Create click intent on a widget
    ///
    /// when clicked the intent will received by the broadcast AppWidgetBroadcastReceiver
    /// the receiver will expose the click event to dart callback
    ///
    /// by default will use widgetId as requestCode to make sure the intent doesn't replace existing
    /// widget intent.
    /// The callback will return widgetId, itemId (if supplied) and stringUid (if supplied)
    /// This parameters can be use on app side to easily fetch the data from database or API
    /// without storing in sharedPrefs.
    ///
    ///
    private fun createPendingClickIntent(
        activityClass: Class<*>,
        widgetId: Int,
        payload: String?,
        url: String?
    ): PendingIntent {
        val clickIntent = Intent(context, activityClass)
        clickIntent.action = AppWidgetPlugin.CLICK_WIDGET_ACTION
        clickIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
        clickIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
        clickIntent.putExtra(AppWidgetPlugin.EXTRA_PAYLOAD, payload)
        if (url != null) clickIntent.data = (Uri.parse(url))

        var pendingIntentFlag = PendingIntent.FLAG_UPDATE_CURRENT
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            pendingIntentFlag =  pendingIntentFlag or PendingIntent.FLAG_IMMUTABLE
        }

        return PendingIntent.getActivity(context, widgetId, clickIntent, pendingIntentFlag)
    }

    /// force reload the widget and this will trigger onUpdate in broadcast receiver
    private fun reloadWidgets(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        val androidPackageName = call.argument<String>("androidPackageName")
            ?:  context.packageName
        val widgetProviderName = call.argument<String>("androidProviderName")
            ?: return result.error(
                "-1",
                "widgetProviderName is required!",
                null
            )

        return try {
            val widgetClass = Class.forName("$androidPackageName.$widgetProviderName")
            val widgetProvider = ComponentName(context, widgetClass)
            val widgetManager = AppWidgetManager.getInstance(context)
            val widgetIds = widgetManager.getAppWidgetIds(widgetProvider)

            val reloadIntent = Intent()
            reloadIntent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
            reloadIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, widgetIds)
            context.sendBroadcast(reloadIntent)
            result.success(true)
        } catch (exception: Exception) {
            result.error("-2", exception.message, exception)
        }
    }

}
