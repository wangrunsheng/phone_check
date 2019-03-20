//import 'package:vibrate/vibrate.dart';

import 'package:vibration/vibration.dart';
import 'package:flutter/services.dart';
import 'android_info.dart';

//import 'package:permission/permission.dart';
//import 'package:permission_handler/permission_handler.dart';
//import 'package:simple_permissions/simple_permissions.dart';

class AndroidPlatform {
  static const EventChannel _eventChannel =
      EventChannel('wang.runsheng.test/charging');

  static listenCharging(Function onEvent, Function onError) {
    _eventChannel.receiveBroadcastStream().listen(onEvent, onError: onError);
  }

  static testVibrate() async {
    print('trying to vibrate the android phone.');
    await platform.invokeMethod('testVibrate');
  }

  static cancelVibrate() {
    Vibration.cancel();
  }

  static testWifi() async {
    await platform.invokeMethod('testWifi');
  }

  static testCharging() async {
    await platform.invokeMethod('testCharging');
  }

  static testMicrophone() async {
    await platform.invokeMethod('testMicrophone');
  }

  static testCall() async {
    try {
//      Permission.getSinglePermissionStatus(PermissionName.Phone).then((status) {
//        print('the phone permission is $status');
//
//      });

//      PermissionHandler()
//          .checkPermissionStatus(PermissionGroup.phone)
//          .then((status) {
//        print('the phone permission is $status');
//      });

//    SimplePermissions.checkPermission(Permission.CallPhone).then((isGranted) {
//      print("the phone permission is: $isGranted");
//
//    });

      await platform.invokeMethod('testCall');
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  static void testBluetooth() async {
    await platform.invokeMethod('testBluetooth');
  }

  static void testGsp() async {
    await platform.invokeMethod('testGps');
  }

  static void testInfraRed() async {
    await platform.invokeMethod('testInfraRed');
  }

  static void switchToSpeaker() async {
    await platform.invokeMethod('switchToSpeaker');
  }

  static void switchToReceiver() async {
    await platform.invokeMethod('switchToReceiver');
  }

  static void testReceiver() async {
    await platform.invokeMethod('testReceiver');
  }

  static void testNFC() async {
    await platform.invokeMethod('testNFC');
  }

  static void testIRIS() async {
    await platform.invokeMethod('testIRIS');
  }
}
