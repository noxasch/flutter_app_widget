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
import tech.noxasch.app_widget.AppWidgetPlugin

class AppWidgetExampleProvider : AppWidgetProvider()
