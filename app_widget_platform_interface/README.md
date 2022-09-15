# app_widget_platform_interface

 Common platform interface for [app_widget](https://pub.dev/packages/app_widget) plugin.

## Usage

To implement a new platform-specific, extend `AppWidgetPlatform` with a `registerWith` as static method that set default
`AppWidgetPlatform.instance = AppWidgetMyPlatform();`. And then create another class `AppWidgetMyPlatformlugin` with an implementation that performs the platform-specific behavior. Finally add your platform initialization in AppWidgetPlugin private
constructor to reinstantiate with the platform specific implementation `AppWidgetPlatform.instance = AppWidgetMyPlatformPlugin();` when the app run. This is because the plugin registrar will register the first intance before `FlutterWidgetBindings.ensureInitialized()` and will throw an error if we try to access any `methodChannel`.

We try to avoid breaking changes at all. Try to reuse the existing interface to keep the api clean whenever possible.
