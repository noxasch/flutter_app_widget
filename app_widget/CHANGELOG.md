## 0.4.0
* breaking changes: `configureWidget` and `updateWidget` accept `layoutId` instead of `layoutName`
* breaking changes: `onConfigureWidget` now accept 3 params (`widgetId`, `layoutId`, `layoutName`)

## 0.3.1
* fix(android): fix trigger update widget updating the widget multiple time

## 0.3.0
* feat(android): support widget provider with diff androidPackageName
* test: update widget test
* test(android): update integration test

## 0.2.2

* fix(android): `reloadWidgets` to use initialized `androidPackageName`

## 0.2.1

* fix(android): onClickWidget callback should be independent on each widget

## 0.2.0

* rename interface into more generic
* feat(android): support uri payload for onClick intent
* fix: onClickWidget callback are now called properly

### Breaking Changes
- `androidPackageName` are no longer accepted in `configureWidget` and `updateWidget` method
- `onClickWidget` callback now accept a string instead of Map

## 0.1.1

* perf: improve configure widget callback response
* fix: fix reload wigdets
* fix: fix getWidgetIds
* docs: update docs
* docs: update example app

## 0.1.0

* Support flavored app
* Fix update method
* finalized android params name

## 0.0.4

* implement `handleConfigureAction` android method

## 0.0.3

* implement getWidgetIds api - Android

## 0.0.2

* implement updateWidget api - Android
* remove debug log - Android and Dart

## 0.0.1

* implement configureWidget api - Android
* implement cancelConfifureWidget api - Android
* implement reloadWidgets api - Android
* implement widgetExist api - Android
* implement onConfigureWidget callback api - Android
* implement onClickWidget callback api - Android
