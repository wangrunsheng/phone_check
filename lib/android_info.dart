import 'dart:async';
import 'package:flutter/services.dart';
import 'package:system_info/system_info.dart';
import 'package:device_info/device_info.dart';

const int MEGABYTE = 1024 * 1024;

class AndroidInfo {
  static const platform = const MethodChannel('wang.runsheng.test/android');

  static Future<String> getMemorySize() async {
    var result = "Error";
    try {
      result = await platform.invokeMethod('totalInternalMemorySize');
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return result;
  }

  static showToast(String msg) async {
    try {
      await platform.invokeMethod('showToast', {'msg': msg});
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  static Future<String> getAndroidTime() async {
    var str;
    try {
      str = await platform.invokeMethod('getAndroidTime');
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return str;
  }

  static Future<String> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('android model: ${androidInfo.model}');

    return androidInfo.model;
  }

  getSystemInfo() {
    print("Kernel architecture     : ${SysInfo.kernelArchitecture}");
    print("Kernel bitness          : ${SysInfo.kernelBitness}");
    print("Kernel name             : ${SysInfo.kernelName}");
    print("Kernel version          : ${SysInfo.kernelVersion}");
    print("Operating system name   : ${SysInfo.operatingSystemName}");
    print("Operating system version: ${SysInfo.operatingSystemVersion}");
    print("User directory          : ${SysInfo.userDirectory}");
    print("User id                 : ${SysInfo.userId}");
    print("User name               : ${SysInfo.userName}");
    print("User space bitness      : ${SysInfo.userSpaceBitness}");
    var processors = SysInfo.processors;
    print("Number of processors    : ${processors.length}");
    for (var processor in processors) {
      print("  Architecture          : ${processor.architecture}");
      print("  Name                  : ${processor.name}");
      print("  Socket                : ${processor.socket}");
      print("  Vendor                : ${processor.vendor}");
    }
    print(
        "Total physical memory   : ${SysInfo.getTotalPhysicalMemory() ~/ MEGABYTE} MB");
    print(
        "Free physical memory    : ${SysInfo.getFreePhysicalMemory() ~/ MEGABYTE} MB");
    print(
        "Total virtual memory    : ${SysInfo.getTotalVirtualMemory() ~/ MEGABYTE} MB");
    print(
        "Free virtual memory     : ${SysInfo.getFreeVirtualMemory() ~/ MEGABYTE} MB");
  }
}
