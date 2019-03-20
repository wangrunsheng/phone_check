import 'dart:io';
import 'dart:async';
import 'package:phone_check/android_info.dart';
import 'ios_platform.dart';
import 'android_platform.dart';
import 'package:vibration/vibration.dart';

class FlutterPlatform {
  static bool isAndroid = true;

  static void checkPlatform() {
    isAndroid = Platform.isAndroid;
  }

  static Future<String> getDeviceMode() async {
    if (isAndroid) {
      return AndroidInfo.getDeviceInfo();
    }
    return iOSPlatform.getDeviceModel();
  }

  static void listenCharging(Function onEvent, Function onError) {
    if (isAndroid) {
      AndroidPlatform.listenCharging(onEvent, onError);
    } else {
      iOSPlatform.listenCharging(onEvent, onError);
    }
  }

  static void testWifi() {
    if (isAndroid) {
      AndroidPlatform.testWifi();
    }
  }

  static void testCall() {
    if (isAndroid) {
      AndroidPlatform.testCall();
    } else {
      iOSPlatform.testCall();
    }
  }

  static void testCharging() {
    if (isAndroid) {
      AndroidPlatform.testCharging();
    } else {
      iOSPlatform.testCharging();
    }
  }

  static void testMicrophone() {
    if (isAndroid) {
      AndroidPlatform.testMicrophone();
    }
  }

  static void testVibrate() {
    if (isAndroid) {
      AndroidPlatform.testVibrate();
    } else {
      iOSPlatform.testVibrate();
    }
  }

  static void startVibration() {
    print('vibration started...');

    Vibration.vibrate(duration: 10000);
  }

  static void stopVibration() {
    print('vibration is canceled...');

    Vibration.cancel();
  }

  static void testBluetooth() {
    print('testing bluetooth print from flutter. ');
    if (isAndroid) {
      AndroidPlatform.testBluetooth();
    }
  }

  static int keepIndex() {
    if (isAndroid) {
      return 0;
    } else {
      return iOSPlatform.keepIndex();
    }
  }

  static void testGsp() {
    if (isAndroid) {
      AndroidPlatform.testGsp();
    }
  }

  static void testInfraRed() {
    if (isAndroid) {
      AndroidPlatform.testInfraRed();
    }
  }

  static void switchToSpeaker() {
    if (isAndroid) {
      AndroidPlatform.switchToSpeaker();
    } else {
      iOSPlatform.switchToSpeaker();
    }
  }

  static void switchToReceiver() {
    if (isAndroid) {
      AndroidPlatform.switchToReceiver();
    } else {
      iOSPlatform.switchToReceiver();
    }
  }

  static void testReceiver() {
    if (isAndroid) {
      AndroidPlatform.testReceiver();
    } else {}
  }

  static void testNFC() {
    if (isAndroid) {
      AndroidPlatform.testNFC();
    }
  }

  static void testIRIS() {
    if (isAndroid) {
      AndroidPlatform.testIRIS();
    }
  }
}
