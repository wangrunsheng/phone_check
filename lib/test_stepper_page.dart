import 'package:flutter/material.dart';

import 'styles.dart';
import 'camera_page.dart';
import 'data/test_steps.dart';

const String font_camera_hero_tag = 'FontCamera';
const String controls_hero_tag = "ControlsButton";
const String left_controls_hero_tag = "LeftControlsButton";
const String right_controls_hero_tag = "RightControlsButton";

class TestStepperPage extends StatefulWidget {
  @override
  _TestStepperPageState createState() => _TestStepperPageState();
}

class _TestStepperPageState extends State<TestStepperPage> {
  int current_step = 0;

  double progress = 0.0;
  String progressPercent = '0%';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
        elevation: 0.0,
        titleSpacing: 0.0,
        backgroundColor: Color.fromARGB(255, 73, 170, 249),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: ListView(
              children: <Widget>[
                Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Image.asset('assets/images/testing.gif'),
                    Container(
                      width: 320.0,
                      child: Visibility(
                        visible: false,
                        child: RaisedButton(
                          child: Text(
                            'Upload',
                            style: Styles.uploadTextStyle,
                          ),
                          color: Colors.white,
                          splashColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          onPressed: () {},
                        ),
                        replacement: Text(
                          progressPercent,
                          textAlign: TextAlign.center,
                          style: Styles.replacementTextStyle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: LinearProgressIndicator(
                        value: progress,
                      ),
                    ),
                  ],
                ),
                Stepper(
                  controlsBuilder: (BuildContext context,
                      {VoidCallback onStepContinue,
                      VoidCallback onStepCancel}) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: onStepContinue,
                          child: const Text(
                            'OK',
                            style: Styles.textWhite,
                          ),
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 40.0,
                        ),
                        RaisedButton(
                          onPressed: onStepCancel,
                          child: const Text(
                            'Fail',
                            style: Styles.textWhite,
                          ),
                          color: Colors.red,
                        ),
                      ],
                    );
                  },
                  currentStep: this.current_step,
                  steps: test_steps,
                  type: StepperType.vertical,
                  onStepTapped: (step) {
                    setState(() {
                      current_step = step;
                      progress = (step + 1) / 15;
                      progressPercent =
                          '${(progress * 100).toStringAsFixed(2)}%';
                      test_steps[step] = _completeStep(test_steps[step]);
                    });

                    if (step == 9) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) {
                          return CameraPage();
                        }),
                      );
                    }
                  },
                  onStepCancel: () {},
                  onStepContinue: () {
                    setState(() {
                      current_step++;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Step _completeStep(Step step) {
  return Step(
      isActive: true,
      title: step.title,
      content: step.content,
      state: StepState.complete);
}

enum Department {
  treasury,
  state,
}
