import 'package:flutter/material.dart';
import 'package:phone_check/styles.dart';
import 'package:phone_check/test_page.dart';

List<Step> test_steps = [
    Step(
      title: Text('Vibiration'),
      subtitle: Text('sub title'),
      content: Text('Is Vibirating?'),
      state: StepState.complete,
      isActive: false,
    ),
    Step(
      title: Text('Microphone'),
      content: Text('Is Micophone Ok?'),
      state: StepState.disabled,
      isActive: false,
    ),
    Step(
      title: Text('Speaker'),
      content: Text('Is Speaker OK?'),
      state: StepState.editing,
      isActive: false,
    ),
    Step(
      title: Text('GPS'),
      content: Text('''Is GPS OK?Is GPS OK?Is GPS OK?Is GPS OK?Is GPS OK?
          Is GPS OK?Is GPS OK?Is GPS OK?Is GPS OK?Is GPS OK?Is GPS OK?Is GPS OK?Is GPS OK?
          Is GPS OK?Is GPS OK?Is GPS OK?Is GPS OK?Is GPS OK?'''),
      state: StepState.error,
      isActive: false,
    ),
    Step(
      title: Text('Compass'),
      content: SizedBox(
        height: 180.0,
        child: Text('Is Compass OK?'),
      ),
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
      content: Column(
        children: <Widget>[
          Container(
            width: 40.0,
            height: 40.0,
            child: Hero(
              tag: font_camera_hero_tag,
              child: Image.asset('assets/images/start_qr_btn.png'),
            ),
          ),
          Text(
            'Is Front Camera OK?',
            style: Styles.textBlack42,
          ),
        ],
      ),
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