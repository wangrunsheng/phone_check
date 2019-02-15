import 'package:flutter/material.dart';

import 'package:phone_check/styles.dart';
import 'camera_page.dart';
import 'package:phone_check/data/test_steps.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:phone_check/android_platform.dart';

const String font_camera_hero_tag = 'FontCamera';
const String controls_hero_tag = "ControlsButton";
const String left_controls_hero_tag = "LeftControlsButton";
const String right_controls_hero_tag = "RightControlsButton";



class TestStepperPage extends StatefulWidget {
  @override
  _TestStepperPageState createState() => _TestStepperPageState();
}

class _TestStepperPageState extends State<TestStepperPage> {
  int currentStep = 0;
  List<Step> currentSteps = List.of(test_steps);

  double progress = 0.0;
  String progressPercent = '0%';

  ScrollController controller = ScrollController();

  bool isFinish = false;

  @override
  void initState() {
    super.initState();
    AndroidPlatform.listenCharging(_onEvent, _onError);
  }

  void _onEvent(Object event) {
    print("the succeed event is: " + event.toString());
    setState(() {

      nextStep(true);

      if(currentStep == 0) {

      }
    });
  }

  void _onError(Object error) {
    setState(() {
      nextStep(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentStep == 0) {
      AndroidPlatform.vibrate();
    }
    if (currentStep == 1) {
      AndroidPlatform.testMicrophone();
      
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
        elevation: 0.0,
        titleSpacing: 0.0,
        backgroundColor: Color.fromARGB(255, 73, 170, 249),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                currentSteps = List.of(test_steps);
                reset();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: Stack(
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
          ),
          Expanded(
            child: Stepper(
              controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {

                if (currentStep == 1) {
                  return Center(
                    child: SpinKitRotatingCircle(
                      color: Colors.blue,
                      size: 50.0,
                    ),
                  );
                }

                if (currentStep == 14) {
                  if (isFinish) {
                    return Center(
                      child: Container(
                        width: 320.0,
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
                      ),
                    );
                  }
                }

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
              currentStep: this.currentStep,
              steps: currentSteps,
              type: StepperType.vertical,
              controller: controller,
              onStepCancel: () {
                setState(() {
                  nextStep(false);
                });
              },
              onStepContinue: () {
                setState(() {
                  nextStep(true);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  nextStep(bool isSuccess) {
    if (isSuccess) {
      currentSteps[currentStep] = _completeStep(test_steps[currentStep]);
    } else {
      currentSteps[currentStep] = _failStep(test_steps[currentStep]);
    }

    if (currentStep == 0) {
      AndroidPlatform.cancelVibrate();
    }


    if (currentStep < currentSteps.length - 1) {
      currentStep++;
      controller.animateTo(72.0 * currentStep,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
      progress = currentStep / 15;
      progressPercent = '${(progress * 100).toStringAsFixed(2)}%';
    } else {
      progress = 1.0;
      progressPercent = '100%';
      isFinish = true;
    }
  }

  Step _failStep(Step step) {
    return Step(
        isActive: true,
        title: step.title,
        content: step.content,
        state: StepState.error);
  }

  Step _completeStep(Step step) {
    return Step(
        isActive: true,
        title: step.title,
        content: step.content,
        state: StepState.complete);
  }

  reset() {
    currentStep = 0;
    progress = 0;
    progressPercent = '0%';
    controller.animateTo(0.0,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
    isFinish = false;
  }
}
