import 'package:flutter/material.dart';
import 'dart:async';
import 'styles.dart';
import 'android_info.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'page/test_page.dart';
import 'android_platform.dart';
import 'page/start_page.dart';
import 'page/test_stepper_page.dart';
import 'package:camera/camera.dart';
import 'dart:io';

List<CameraDescription> cameras;

void logError(String code, String message) => print('Error: $code\nError Message: $message');

Future<void> main() async {
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
//      home: TestPage(),
//      home: TestStepperPage(),
    );
  }
}
