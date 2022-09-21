package tech.noxasch.app_widget

import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import androidx.annotation.Keep
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry


@Keep
class AppWidgetPlugin: FlutterPlugin, ActivityAware,
  PluginRegistry.NewIntentListener {

  private var activity: Activity? = null
  private var methodCallHandler: AppWidgetMethodCallHandler? = null

  /// namespacing constant that need to be access from outside.
  /// similar to android string constant pattern
  companion object {
    @JvmStatic
    val TAG = "APP_WIDGET_PLUGIN"
    @JvmStatic
    val CHANNEL = "tech.noxasch.flutter/app_widget_foreground"
    @JvmStatic
    val CONFIGURE_WIDGET_ACTION_CALLBACK = "tech.noxasch.flutter.CONFIGURE_CALLBACK"
    @JvmStatic
    val CLICK_WIDGET_ACTION = "tech.noxasch.flutter.CLICK_WIDGET"
    @JvmStatic
    val CLICK_WIDGET_ACTION_CALLBACK = "tech.noxasch.flutter.CLICK_CALLBACK"

    @JvmStatic
    val EXTRA_PAYLOAD = "dataPayload"
    @JvmStatic
    val EXTRA_APP_ITEM_ID = "appItemId"
    @JvmStatic
    val EXTRA_APP_STRING_UID = "appStringUid"

    @JvmStatic
    val ON_CONFIGURE_WIDGET_CALLBACK = "onConfigureWidget"
    @JvmStatic
    val ON_ClICK_WIDGET_CALLBACK = "onClickWidget"

    // this method rethrow intent with a different name
    // to pass intent to onNewIntent
    // calling methodChannel in other method is too early
    // since they are called before flutter Ui is displayed
    @JvmStatic
    fun handleWidgetAction(context: Context, intent: Intent) {
      when(intent.action) {
        AppWidgetManager.ACTION_APPWIDGET_CONFIGURE -> handleConfigureAction(context, intent)
        CLICK_WIDGET_ACTION -> handleOnClickAction(context, intent)
      }
    }

    @JvmStatic
    private fun handleOnClickAction(context : Context, intent: Intent) {
      val clickIntent = Intent(context, context.javaClass)
      clickIntent.action = CLICK_WIDGET_ACTION_CALLBACK

      clickIntent.putExtras(intent)
      context.startActivity(clickIntent)
    }

    @JvmStatic
    private fun handleConfigureAction(context : Context, intent: Intent) {
      val extras = intent.extras
      val widgetId: Int = extras?.getInt(AppWidgetManager.EXTRA_APPWIDGET_ID) ?: return
      if (widgetId == 0) return

      val configIntent = Intent(context, context.javaClass)
      configIntent.action = CONFIGURE_WIDGET_ACTION_CALLBACK
      configIntent.putExtra("widgetId", widgetId)
      context.startActivity(configIntent)
    }
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    methodCallHandler = AppWidgetMethodCallHandler(flutterPluginBinding.applicationContext)
    methodCallHandler!!.open(flutterPluginBinding.binaryMessenger)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    methodCallHandler!!.close()
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addOnNewIntentListener(this)
    methodCallHandler!!.setActivity(activity)
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

  // this only called when the activity already started
  // we need to rethrow the intent here since we don't have access to onUiDisplayed
  override fun onNewIntent(intent: Intent): Boolean {
    if (intent.action != null) {
      when (intent.action) {
        CONFIGURE_WIDGET_ACTION_CALLBACK -> methodCallHandler!!.handleConfigureIntent(intent)
        CLICK_WIDGET_ACTION_CALLBACK -> methodCallHandler!!.handleClickIntent(intent)
      }
    }

    return false
  }
}
