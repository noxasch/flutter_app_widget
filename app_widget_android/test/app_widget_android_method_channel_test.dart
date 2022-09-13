// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:app_widget_android/app_widget_android_method_channel.dart';

// void main() {
//   MethodChannelAppWidgetAndroid platform = MethodChannelAppWidgetAndroid();
//   const MethodChannel channel = MethodChannel('app_widget_android');

//   TestWidgetsFlutterBinding.ensureInitialized();

//   setUp(() {
//     channel.setMockMethodCallHandler((MethodCall methodCall) async {
//       return '42';
//     });
//   });

//   tearDown(() {
//     channel.setMockMethodCallHandler(null);
//   });

//   test('getPlatformVersion', () async {
//     expect(await platform.getPlatformVersion(), '42');
//   });
// }
