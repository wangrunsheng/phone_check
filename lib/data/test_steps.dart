import 'package:flutter/material.dart';
import 'package:phone_check/styles.dart';
import 'package:phone_check/page/test_page.dart';

import 'package:phone_check/android_platform.dart';

import 'package:phone_check/data/test_info.dart';

String orderNumber;

int estAmountInt = 0;

List<TestStep> testStepList = [];

List<Step> testSteps = [
  Step(
    title: Text('Lcd Display'),
    content: Text('Is Display Good?'),
  ),
  Step(
    title: Text('Wifi'),
    content: Text('Is Wifi Good?'),
  ),
  Step(
    title: Text('Gsm Network'),
    content: Text('Is Gsm Network Good?'),
  ),
  Step(
    title: Text('Charging Function'),
    content: Text('Is Charging Function Good?'),
  ),
  Step(
    title: Text('Mic(Recording Test)'),
    content: Text('Is Mic Good?'),
  ),
  Step(
    title: Text('Headset Test'),
    content: Text('Is Headset Good?'),
  ),
  Step(
    title: Text('Front Camera Test'),
    content: Text('Is Front Camera Good?'),
  ),
  Step(
    title: Text('Rear Camera Test'),
    content: Text('Is Rear Camera Good?'),
  ),
  Step(
    title: Text('Vibrate Function'),
    content: Text('Is Vibration Good?'),
  ),
  Step(
    title: Text('Fingerprint'),
    content: Text('Is Fingerprint Good?'),
  ),
  Step(
    title: Text('Body/Housing'),
    content: Text('Is Body/Housing Good?'),
  ),
  Step(
    title: Text('Lcd Glass(Kaca Lcd)'),
    content: Text('Is Display Good?'),
  ),
  Step(
    title: Text('Sim Lock'),
    content: Text('Is Sim Lock?'),
  ),
  Step(
    title: Text('Phone Lock'),
    content: Text('Is Phone Lock?'),
  ),
  Step(
    title: Text('Bluetooth'),
    content: Text('Is Bluetooth Good?'),
  ),
  Step(
    title: Text('Gps Function'),
    content: Text('Is Gps Function Good?'),
  ),
  Step(
    title: Text('Button Funciton'),
    content: Text('Is Button Function Good?'),
  ),
  Step(
    title: Text('S-Pen Test'),
    content: Text('Is S-Pen Good?'),
  ),
  Step(
    title: Text('Nfc Test'),
    content: Text('Is Nfc Good?'),
  ),
  Step(
    title: Text('Infra Red Test'),
    content: Text('Is Infa Red Good?'),
  ),
  Step(
    title: Text('Iris Test'),
    content: Text('Is Iris Good?'),
  ),
];

List<Step> test_steps = [
  Step(
    title: Text('Vibiration'),
    subtitle: Text('sub title'),
    content: Text('Is Vibirating?'),
    state: StepState.editing,
    isActive: false,
  ),
  Step(
    title: Text('Microphone'),
    content: Text('Is Micophone Ok?'),
    state: StepState.indexed,
    isActive: false,
  ),
  Step(
    title: Text('Speaker'),
    content: Text('Is Speaker OK?'),
    state: StepState.indexed,
    isActive: false,
  ),
  Step(
    title: Text('GPS'),
    content: Text('Is GPS OK?'),
    state: StepState.indexed,
    isActive: false,
  ),
  Step(
    title: Text('Compass'),
    content: Text('Is Compass OK?'),
    state: StepState.indexed,
    isActive: false,
  ),
  Step(
    title: Text('Wifi'),
    content: Text('Is Wifi OK?'),
    isActive: false,
  ),
  Step(
    title: Text('Acceleration Sensor'),
    content: Text('Is Acceleration Sensor OK?'),
    isActive: false,
  ),
  Step(
    title: Text('Gyroscope'),
    content: Text('Is Gyroscope OK?'),
    isActive: false,
  ),
  Step(
    title: Text('Flash'),
    content: Text('Is Flash OK?'),
    isActive: false,
  ),
  Step(
    // index = 9
    title: Text('Front Camera'),
    content: Text('Is Front Camera OK?'),
    isActive: false,
  ),
  Step(
    title: Text('Rear Camera'),
    content: Text('Is Rear Camera OK?'),
    isActive: false,
  ),
  Step(
    title: Text('Telephone'),
    content: Text('Is Telephone OK?'),
    isActive: false,
  ),
  Step(
    // index = 12
    title: Text('Charging'),
    content: Text('Is Charging OK?'),
    isActive: false,
  ),
  Step(
    title: Text('Touching'),
    content: Text('Is Touching OK?'),
    isActive: false,
  ),
  Step(
    title: Text('Display'),
    content: Text('Is Display OK?'),
    isActive: false,
  ),
];

List<Function> test_function = [
  AndroidPlatform.testVibrate(),
  () => print('micophone test'),
];

runTestFunction(int step) {
  switch (step) {
    case 0:
      AndroidPlatform.testVibrate();
      break;
    case 12:
      break;

    default:
  }
}
