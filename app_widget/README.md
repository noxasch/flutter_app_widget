# App Widget

This plugin attempt to exposed as much useful API and callback to flutter to reduce
going back and forth to native and make buidling app widget / home screen widget easier.

## Plaform Support

| Android | iOS |
| :-----: | :-: |
|   ✔️    |   |

## Using this package

### Platform setup

#### Android

> Note: It is advisable to do this setup using Android Studio since it help you design the widget layout and proper linting and import in kotlin file.


1. Add widget layout in `android/app/src/main/res/layout/example_layout.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>

<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:layout_margin="8dp"
    android:orientation="vertical"
    android:gravity="center"
    android:padding="8dp"
    android:background="@drawable/widget_background"
    android:id="@+id/widget_container">

    <TextView
        android:id="@+id/widget_title"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:textSize="36sp"
        android:textStyle="bold"
        tools:text="Title" />

    <TextView
        android:id="@+id/widget_message"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:textSize="18sp"
        tools:text="Message" />
</LinearLayout>
```

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
   android:configure - full app name .MainActivity
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

  - add receiver for widget provider to listen to widget event (after Activity block)

  ```xml
  </activity>
  <!-- after or outside activity -->
  <receiver android:exported="true" android:name="MyWidgetProvider">
      <intent-filter>
          <action android:name="android.appwidget.action.APPWIDGET_UPDATE"/>
          <action android:name="android.appwidget.action.APPWIDGET_DELETED"/>
      </intent-filter>
      <meta-data android:name="android.appwidget.provider"
          android:resource="@xml/app_widget_example_info" />
  </receiver>
  ```
4. Create the widget provider in `android/app/src/main/kotlin/your/domain/path/MyWidgetExampleProvider.kt`
Inherit from Android `AppWidgetProvider` and implement the required method if needed. Since the plugin already provice interface to update widget, we can leave it empty and handle it on dart/flutter side.

    Probably you want to implement `onDeleted` or `onDisabled` method to handle cleanup like removing the widget Id from sharedPrefences allow user to add multiple widget.

```kotlin
class MyWidgetExampleProvider : AppWidgetProvider() {
}
```

5. Update MainActivity to handle `onConfigure` intent

```kotlin
package com.example.my_app

import android.appwidget.AppWidgetManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import tech.noxasch.app_widget.AppWidgetPlugin

class MainActivity: FlutterActivity() {
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    // Add this block
    if (intent.action == AppWidgetManager.ACTION_APPWIDGET_CONFIGURE) {
      AppWidgetPlugin.Companion.handleConfigureAction(context, intent)
    }
  }
}
```

6. By now you should be able to add a widget. Next step is to configure it from flutter side
and make sure the widget configured.

7. Implement onEnabled (update widget on reboot) - this has to be done from android ?

6. Implement android WidgetProvider - Already done

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
// this method can be declare as a top level function or inside a widget
void onConfigureWidget(int widgetId) {
  // handle widget configuration
  // eg:
  // redirect or use launchUrl and deeplink redirect to configuration page
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
   // change to androidPackageName - we needed as param since there is no standard on how long the domain name can be
  androidPackageName: 'tech.noxasch.app_widget_example',
  widgetId: _widgetId!,
  widgetLayout: 'example_layout',
  textViewIdValueMap: {
    'widget_title': 'MY WIDGET',
    'widget_message': 'This is my widget message'
});
```

#### handling onClickWidget

```dart
// this method can be declare as a top level function or inside a widget
void onClickWidget(int widgetId) {
  // handle click widget event
  // eg:
  // redirect to item page
  // use launchUrl and deeplink redirect
}

// onClickWidget callback are optional
final appWidgetPlugin = AppWidgetPlugin(
  onConfigureWidget: onConfigureWidget,
  onClickWidget: onClickWidget
);
```

#### Updating widget
There are two ways we can update the widget on Android:

1. Using sharedPreferences and AppWidgetProvider
2. Using workmanager scheduled task

You can get the `widgetId` if you store the id during `onConfigureWidget` or call `appWidgetPlugin.getWidgetIds()`
to get all widgets Id.

Most of the time you'll want to update widget via workmanager. See below
how to use the extension in workmanager.

```dart
appWidgetPlugin.updateWidget(
  androidPackageName: 'tech.noxasch.app_widget_example',
  widgetId: _widgetId!,
  widgetLayout: 'example_layout',
  textViewIdValueMap: {
    'widget_title': 'MY WIDGET',
    'widget_message': 'This is my widget message'
});
```

#### Using Workmanager
TODO

#### Dark Mode
- move this to blog post add link and also link to android official docs

## Checklist
- [x] Unit Test
- [ ] update documentation
- [ ] Update example app
- [ ] Update Screenshot
- [ ] iOS support
