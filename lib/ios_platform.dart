import 'package:phone_check/ios_platform.dart';
import 'dart:async';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

class iOSPlatform {
  static const MethodChannel _methodChannel =
      MethodChannel('phonecheck.runsheng.wang/method');
  static const EventChannel _eventChannel =
      EventChannel('phonecheck.runsheng.wang/event');

  static String machine;

  static listenCharging(Function onEvent, Function onError) {
    _eventChannel.receiveBroadcastStream().listen(onEvent, onError: onError);
  }

  static Future<String> getDeviceModel() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;

    machine = iosDeviceInfo.utsname.machine;
    return _modelConvert();
  }

  static void testVibrate() {
    _methodChannel.invokeMethod('testVibrate');
  }

  static void testCall() {
    _methodChannel.invokeMethod('testCall');
  }

  static void testCharging() {
    _methodChannel.invokeMethod('testCharging');
  }

  static String _modelConvert() {
    if (machine == "i386") return "Simulator";

    if (machine == "x86_64") return "Simulator";

    if (machine == "iPhone5,1") return "iPhone 5";

    if (machine == "iPhone5,2") return "iPhone 5";

    if (machine == "iPhone5,3") return "iPhone 5c";

    if (machine == "iPhone5,4") return "iPhone 5c";

    if (machine == "iPhone6,1") return "iPhone 5s";

    if (machine == "iPhone6,2") return "iPhone 5s";

    if (machine == "iPhone7,1") return "iPhone 6 Plus";

    if (machine == "iPhone7,2") return "iPhone 6";

    if (machine == "iPhone8,1") return "iPhone 6s";

    if (machine == "iPhone8,2") return "iPhone 6s Plus";

    if (machine == "iPhone8,4") return "iPhone SE";

    if (machine == "iPhone9,1") return "iPhone 7";

    if (machine == "iPhone9,2") return "iPhone 7 Plus";

    if (machine == "iPhone10,1") return "iPhone 8";

    if (machine == "iPhone10,4") return "iPhone 8";

    if (machine == "iPhone10,2") return "iPhone 8 Plus";

    if (machine == "iPhone10,5") return "iPhone 8 Plus";

    if (machine == "iPhone10,3") return "iPhone X";

    if (machine == "iPhone10,6") return "iPhone X";

    if (machine == "iPhone10,8") return "iPhone XR";

    if (machine == "iPhone10,2") return "iPhone XS";

    if (machine == "iPhone10,4") return "iPhone XS Max";

    if (machine == "iPhone10,6") return "iPhone XS Max";

    return "iPhone Unknown";
  }

  static int keepIndex() {
    if (machine == "i386") return 0;

    if (machine == "x86_64") return 0;

    if (machine == "iPhone5,1") return 2;

    if (machine == "iPhone5,2") return 2;

    if (machine == "iPhone5,3") return 2;

    if (machine == "iPhone5,4") return 2;

    if (machine == "iPhone6,1") return 2;

    if (machine == "iPhone6,2") return 2;

    if (machine == "iPhone7,1") return 5;

    if (machine == "iPhone7,2") return 4;

    if (machine == "iPhone8,1") return 4;

    if (machine == "iPhone8,2") return 5;

    if (machine == "iPhone8,4") return 2;

    if (machine == "iPhone9,1") return 3;

    if (machine == "iPhone9,2") return 5;

    if (machine == "iPhone10,1") return 3;

    if (machine == "iPhone10,4") return 3;

    if (machine == "iPhone10,2") return 5;

    if (machine == "iPhone10,5") return 5;

    if (machine == "iPhone10,3") return 5;

    if (machine == "iPhone10,6") return 5;

    if (machine == "iPhone10,8") return 5;

    if (machine == "iPhone10,2") return 5;

    if (machine == "iPhone10,4") return 5;

    if (machine == "iPhone10,6") return 5;

    return 2;
  }
}