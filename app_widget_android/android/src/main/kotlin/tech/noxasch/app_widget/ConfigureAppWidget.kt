package tech.noxasch.app_widget

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.Uri
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

// TODO: Implement this in app instead

// this deeplink should open widget config screen
const val DEEP_LINK_URL = ""

class ConfigureAppWidget : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        val action = intent?.action
        if (action != null && action == android.appwidget.AppWidgetManager.ACTION_APPWIDGET_CONFIGURE) {
            val i = Intent()
            i.data = Uri.parse(DEEP_LINK_URL)
            i.action = android.appwidget.AppWidgetManager.ACTION_APPWIDGET_CONFIGURE
            context?.startActivity(i)
        }

    }
}