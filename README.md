[![platform-interface](https://github.com/noxasch/flutter_app_widget/actions/workflows/interface.yaml/badge.svg)](https://github.com/noxasch/flutter_app_widget/actions/workflows/interface.yaml)
[![android](https://github.com/noxasch/flutter_app_widget/actions/workflows/android.yaml/badge.svg)](https://github.com/noxasch/flutter_app_widget/actions/workflows/android.yaml)
[![build](https://github.com/noxasch/flutter_app_widget/actions/workflows/main.yaml/badge.svg)](https://github.com/noxasch/flutter_app_widget/actions/workflows/main.yaml)

# Flutter App Widget
App Widget / Home Screen widget plugin for flutter app

## Usage

Please see [app_widget](./app_widget) subdirectory for the usage documentation.

## Plaform Support

| Android | iOS |
| :-----: | :-: |
|   ✔️    |   |

## Project Structure

This project follow the standard for flutter plugin development where each
pieces are independent of each other. Other platform interface can be easily added
by inherit the base platform interface and expose the require api to the main `app_wiget`
plugin.

## Contributing
0. Fork
1. Checkout to feature branch
2. Add feature and unit test
3. Make sure all unit test pass
4. Add platform integration test and run integration test
5. Create a PR

## Android Integration Test
- Make sure to run on the latest and minSdk supported

in `app_widget/example/integration_test/app_widget_test.dart`

```sh
cd app_widget/example
# this will require a connected device for android
flutter test integration_test/app_widget_test.dart
```
