# app_widget

flutter app widget

## Getting Started

## Platform support
- [x] Android
- [ ] iOS

### Android
Since flutter engine are build on android activity, we cannot directly build
the the widget interface using flutter. Hence it need to be build using XML
the android way.

This plugin introduce some api from the android native and provide some suggestion on how
to include an app widget with you flutter application.

App widget is a like a mini app and are actually separated from your main app.
It have limited capability on it's own and can't actually talk to the main app directly
after the first configuration.

This mean after the first config, there is no way we can talk directly to the widget.
There are two way we can update the widget:

1. Using sharedPreferences and AppWidgetProvider
2. Using workmanager scheduled task


## Using this package

### Platform setup

#### Android

1. Add widget layout

2. Add `appwidget-provider` info `android/app/src/main/res/xml/my-widget-provider-info`

```xml
<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:minWidth="80dp"
    android:minHeight="80dp"
    android:targetCellWidth="3"
    android:targetCellHeight="2"
    android:updatePeriodMillis="86400000"
    android:initialLayout="@layout/example_layout"
    android:configure="tech.noxasch.app_widget_example.MainActivity"
    android:widgetCategory="home_screen"
    android:widgetFeatures="reconfigurable">
</appwidget-provider>
 <!--
   android:configure - named it to your app MainActivity
   android:initialLayout - should point to an actual layout for the widget
   refer to https://developer.android.com/develop/ui/views/appwidgets/overview
 -->
```

3. Update Android manifest `android/app/src/main/AndroidManifest`

  - add intent-filter to the `MainActivity` activity block if you want to support widget initial configuration

  ```xml
    <activity
      android:name=".MainActivity"
      ...>
        ...
        <!-- add this -->
        <intent-filter>
            <action android:name="android.appwidget.action.APPWIDGET_CONFIGURE"/>
        </intent-filter>
    </activity>
  ```

  - add appwidget provider for widget update and deleted intent

  ```xml
  <receiver android:exported="true" android:name="MyWidgetProvider">
      <intent-filter>
          <action android:name="android.appwidget.action.APPWIDGET_UPDATE"/>
          <action android:name="android.appwidget.action.APPWIDGET_DELETED"/>
      </intent-filter>
      <meta-data android:name="android.appwidget.provider"
          android:resource="@xml/app_widget_example_info" />
  </receiver>
  ```
4. Create the widget provider
Inherit from Android `AppWidgetProvider` and implement the required method if needed. Since the plugin already provice interface to update widget, we can leave the `onUpdate` method and handle it on dart side.

    Probably you want to implement `onDeleted` method to handle cleanup like removing the widget Id from sharePrefences allow user to add multiple widget.

5. Update MainActivity to handle `onConfigure` intent

```kotlin
// add this import
import tech.noxasch.app_widget.AppWidgetPlugin

// this need to be implemented manually
class MainActivity: FlutterActivity() {
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    // add this line
    if (intent.action == AppWidgetManager.ACTION_APPWIDGET_CONFIGURE) {
      handleConfigureAction()
    }

  }

  // add this method
  // implement this as static method in App so we can use like this:
  // AppWidgetPlugin.handleConfigureAction(context, intent, widgetId)
  private fun handleConfigureAction() {
    val extras = intent.extras
    val widgetId: Int = extras?.getInt(AppWidgetManager.EXTRA_APPWIDGET_ID) ?: return
    if (widgetId == 0) return

    val configIntent = intent.setAction(AppWidgetPlugin.CONFIGURE_WIDGET_ACTION)
    configIntent.putExtra("widgetId", widgetId)
    startActivity(configIntent)
  }
}
```

6. Implement android WidgetProvider

7. Handling update in native (Optional) - TODO

7. Implement workmanager in flutter - TODO

### In App Usage and Dart/Flutter Api

This section shows how to use the exposed api by the plugin in your app.

```dart
// instantiate appWidgetPlugin
final appWidgetPlugin = AppWidgetPlugin();
appWidgetPlugin.configureWidget(...)
appWidgetPlugin.cancelConfigure()
```

#### handling onConfigureWidget

```dart
void onConfigureWidget(int widgetId) {
  // handle widget configuration
  // use launchUrl and deeplink redirect to configuration page
}

// onConfigureWidget callback are optional
// without this it will use default value that you set
final appWidgetPlugin = AppWidgetPlugin(
  onConfigureWidget: onConfigureWidget
);

// this changes will reflect on the widget
// only use this method in widget configuration screen as
// it method will close the app which require to signal the widget config completion
appWidgetPlugin.configureWidget(
  androidAppName: 'tech.noxasch.app_widget_example',
  widgetId: _widgetId!,
  widgetLayout: 'example_layout',
  textViewIdValueMap: {
    'widget_title': 'MY WIDGET',
    'widget_message': 'This is my widget message'
});
```

#### handling onClickWidget

```dart
void onClickWidget(int widgetId) {
  // handle click widget event
  // do something
  // use launchUrl and deeplink redirect
}

// onClickWidget callback are optional
final appWidgetPlugin = AppWidgetPlugin(
  onConfigureWidget: onConfigureWidget,
  onClickWidget: onClickWidget
);
```

#### Updating widget
Most of the time you'll want to update widget via workmanager. See below
how to use the extension in workmanager

```dart
appWidgetPlugin.updateWidget(
  androidAppName: 'tech.noxasch.app_widget_example',
  widgetId: _widgetId!,
  widgetLayout: 'example_layout',
  textViewIdValueMap: {
    'widget_title': 'MY WIDGET',
    'widget_message': 'This is my widget message'
});
```

#### Using Workmanager

TODO

## Checklist
- [x] Unit Test
- [ ] Readme documentation
- [ ] Update example app
