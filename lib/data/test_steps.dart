import 'package:flutter/material.dart';
import 'package:phone_check/styles.dart';
import 'package:phone_check/page/test_page.dart';

import 'package:phone_check/android_platform.dart';

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
  AndroidPlatform.vibrate(),
  () => print('micophone test'),
];

runTestFunction(int step) {
  switch (step) {
    case 0:
      AndroidPlatform.vibrate();
      break;
    case 12:
      break;

    default:
  }
}
