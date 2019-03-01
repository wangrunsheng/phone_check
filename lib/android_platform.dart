//import 'package:vibrate/vibrate.dart';

import 'package:vibration/vibration.dart';
import 'package:flutter/services.dart';
import 'android_info.dart';

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
      await platform.invokeMethod('testCall');
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }
}
