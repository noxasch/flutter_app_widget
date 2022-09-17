package tech.noxasch.app_widget

import android.app.Activity
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProviderInfo
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.RemoteViews
import androidx.annotation.Keep
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry


@Keep
class AppWidgetPlugin: FlutterPlugin, MethodCallHandler, ActivityAware,
  PluginRegistry.NewIntentListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel
  private lateinit var context: Context

  private var activity: Activity? = null

  /// namespacing constant that need to be access from outside.
  /// similar to android string constant pattern
  companion object {
    @JvmStatic
    val CHANNEL = "tech.noxasch.flutter/app_widget"
    @JvmStatic
    val CONFIGURE_WIDGET_ACTION = "tech.noxasch.flutter.configureWidget"
    @JvmStatic
    val CLICK_WIDGET_ACTION = "tech.noxasch.flutter.clickWidget"

    @JvmStatic
    val EXTRA_APP_ITEM_ID = "appItemId"
    @JvmStatic
    val EXTRA_APP_STRING_UID = "appStringUid"

    @JvmStatic
    val ON_CONFIGURE_WIDGET_CALLBACK = "onConfigureWidget"
    @JvmStatic
    val ON_ClICK_WIDGET_CALLBACK = "onClickWidget"

    @JvmStatic
    fun handleConfigureAction(context : Context, intent: Intent) {
       val extras = intent.extras
       val widgetId: Int = extras?.getInt(AppWidgetManager.EXTRA_APPWIDGET_ID) ?: return
       if (widgetId == 0) return

       val configIntent = intent.setAction(AppWidgetPlugin.CONFIGURE_WIDGET_ACTION)
       configIntent.putExtra("widgetId", widgetId)
       context.startActivity(configIntent)
     }
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
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

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun getWidgetIds(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val widgetProviderName = call.argument<String>("androidProviderName") ?: return result.success(false)
      val widgetProvider = ComponentName(context, widgetProviderName)
      val widgetManager = AppWidgetManager.getInstance(context)

      val widgetIds = widgetManager.getAppWidgetIds(widgetProvider)

      return result.success(widgetIds)
    } catch (exception: Exception) {
      result.error("-2", exception.message, exception)
    }
  }

  private fun cancelConfigureWidget(@NonNull result: Result) {
    try {
      activity!!.setResult(Activity.RESULT_CANCELED)
      result.success(true)
    } catch (exception: Exception) {
      result.error("-2", exception.message, exception)
    }
  }

  private fun widgetExist(@NonNull call: MethodCall, @NonNull result: Result) {
    val widgetId = call.argument<Int>("widgetId") ?: return result.success(false)
    try {
      val widgetManager = AppWidgetManager.getInstance(context)
      val widgetInfo: AppWidgetProviderInfo =
        widgetManager.getAppWidgetInfo(widgetId) ?: return result.success(false)

      return result.success(true)
    } catch (exception: Exception) {
      result.error("-2", exception.message, exception)
    }
  }

  /// This should be called when configuring individual widgets
  private fun configureWidget(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      if (activity == null) return result.error("-2", "Not attached to any activity!", null)

      val androidPackageName = call.argument<String>("androidPackageName")
        ?: return result.error("-1", "androidPackageName is required!", null)
      val widgetId = call.argument<Int>("widgetId")
        ?: return result.error("-1", "widgetId is required!", null)
      val widgetLayout = call.argument<String>("widgetLayout")
        ?: return result.error("-1", "widgetLayout is required!", null)

      val widgetLayoutId: Int = context.resources.getIdentifier(widgetLayout, "layout", context.packageName)
      val itemId = call.argument<Int>("itemId")
      val stringUid = call.argument<String>("stringUid")
      val activityClass = Class.forName("$androidPackageName.MainActivity")
      val appWidgetManager = AppWidgetManager.getInstance(context)
      val pendingIntent = createPendingClickIntent(activityClass, widgetId, itemId, stringUid)
      val textViewIdValueMap = call.argument<Map<String, String>>("textViewIdValueMap")

      if (textViewIdValueMap != null) {
        val views : RemoteViews = RemoteViews(context.packageName, widgetLayoutId).apply {
          for ((key, value) in textViewIdValueMap) {
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

  // This should only be called after the widget has been configure for the first time
  private fun updateWidget(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      val androidPackageName = call.argument<String>("androidPackageName")
        ?: return result.error("-1", "androidPackageName is required!", null)
      val widgetId = call.argument<Int>("widgetId")
        ?: return result.error("-1", "widgetId is required!", null)
      val widgetLayout = call.argument<String>("widgetLayout")
        ?: return result.error("-1", "widgetLayout is required!", null)

      val widgetLayoutId: Int =
        context.resources.getIdentifier(widgetLayout, "layout", context.packageName)
      val itemId = call.argument<Int>("itemId")
      val stringUid = call.argument<String>("stringUid")
      val activityClass = Class.forName("$androidPackageName.MainActivity")
      val appWidgetManager = AppWidgetManager.getInstance(context)
      val pendingIntent = createPendingClickIntent(activityClass, widgetId, itemId, stringUid)
      val textViewIdValueMap = call.argument<Map<String, String>>("textViewIdValueMap")

      if (textViewIdValueMap != null) {
        val views: RemoteViews = RemoteViews(context.packageName, widgetLayoutId)

        for ((key, value) in textViewIdValueMap) {
          val textViewId: Int =
            context.resources.getIdentifier(key, "id", context.packageName)
          if (textViewId == 0) throw Exception("Id $key does not exist!")

          // only work if widget is blank - so we have to clear it first
          views.setTextViewText(textViewId, "")
          appWidgetManager.partiallyUpdateAppWidget(widgetId, views)
          views.setTextViewText(textViewId, value)
          appWidgetManager.partiallyUpdateAppWidget(widgetId, views)
          views.setOnClickPendingIntent(textViewId, pendingIntent)
          appWidgetManager.partiallyUpdateAppWidget(widgetId, views)
        }
      }

      return result.success(true)
    } catch (exception: Exception) {
      return result.error("-2", exception.message, exception)
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
  private fun createPendingClickIntent(
    activityClass: Class<*>,
    widgetId: Int,
    itemId: Int?,
    stringUid: String?
  ): PendingIntent {
    val intent = Intent(context, activityClass)
    intent.action = CLICK_WIDGET_ACTION
    intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, widgetId)
    intent.putExtra(EXTRA_APP_ITEM_ID, itemId)
    intent.putExtra(EXTRA_APP_STRING_UID, stringUid)

    var pendingIntentFlag = PendingIntent.FLAG_UPDATE_CURRENT
    if (Build.VERSION.SDK_INT >= 23) {
      pendingIntentFlag = PendingIntent.FLAG_IMMUTABLE or pendingIntentFlag
    }

    return PendingIntent.getActivity(context, 0, intent, pendingIntentFlag)
  }

  /// force reload the widget and this will onUpdate in broadcast receiver
  private fun reloadWidgets(@NonNull call: MethodCall, @NonNull result: Result) {
    val androidPackageName = call.argument<String>("androidPackageName")
    val widgetProviderName = call.argument<String>("androidProviderName")

    if (androidPackageName == null) return result.error("-1", "androidPackageName is required!", null)
    if (widgetProviderName == null) return result.error(
      "-1",
      "widgetProviderName is required!",
      null
    )

    try {
      val javaClass = Class.forName(androidPackageName)
//      val widgetProviderClass = Class.forName(widgetProviderName)
      val widgetIds = AppWidgetManager.getInstance(context.applicationContext)
        .getAppWidgetIds(ComponentName(context, javaClass))
      if (widgetIds.isEmpty()) return result.success(true)

      val i = Intent(context, javaClass)
      i.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
      i.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, widgetIds)
      context.sendBroadcast(i)
      result.success(true)
    } catch (exception: ClassNotFoundException) {
      result.error("-2", "No widget registered with $javaClass found!", exception)
    }
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addOnNewIntentListener(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addOnNewIntentListener(this)
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  // This will filter event and invoke appropriate callback on Dart side
  // - onConfigureWidget
  // - onWidgetClick
  override fun onNewIntent(intent: Intent): Boolean {
    if (intent.action != null) {
      when (intent.action) {
        CONFIGURE_WIDGET_ACTION -> handleConfigureIntent(intent)
        CLICK_WIDGET_ACTION -> handleClickIntent(intent)
      }
    }

    return false
  }

  private fun handleConfigureIntent(intent: Intent): Boolean {
    val widgetId = intent.extras!!.getInt("widgetId")
    channel.invokeMethod(ON_CONFIGURE_WIDGET_CALLBACK, mapOf("widgetId" to widgetId))
    return true
  }

  private fun handleClickIntent(intent: Intent): Boolean {
    val widgetId = intent.extras?.getInt(AppWidgetManager.EXTRA_APPWIDGET_ID)
    val itemId = intent.extras?.getInt(AppWidgetPlugin.EXTRA_APP_ITEM_ID)
    val stringUid = intent.extras?.getInt(AppWidgetPlugin.EXTRA_APP_STRING_UID)

    val payload = mapOf(
      "widgetId" to widgetId,
      "itemId" to itemId,
      "stringUid" to stringUid,
    )

    channel.invokeMethod(AppWidgetPlugin.ON_ClICK_WIDGET_CALLBACK, payload)
    return true
  }
}



