import 'package:flutter/material.dart';
import 'dart:async';
import 'styles.dart';
import 'android_info.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'page/test_page.dart';
import 'android_test.dart';
import 'page/start_page.dart';
import 'page/test_stepper_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    //AndroidTool.vibrate();
    
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: TestPage(),
    );
  }
}