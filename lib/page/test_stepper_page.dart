import 'package:flutter/material.dart';

import 'package:phone_check/styles.dart';
import 'camera_page.dart';
import 'package:phone_check/data/test_steps.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:http/http.dart' as http;

import 'package:phone_check/data/test_info.dart';

import 'dart:convert';

import 'package:phone_check/flutter_platform.dart';

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
  List<Step> currentSteps = List.of(testSteps);

  double progress = 0.0;
  String progressPercent = '0%';

  ScrollController controller = ScrollController();

  bool isFinish = false;

  List<TestResult> testResultList = [];

  int amount = estAmountInt;

  @override
  void initState() {
    super.initState();
    FlutterPlatform.listenCharging(_onEvent, _onError);
  }

  void _onEvent(Object event) {
    String result = event.toString();

    print("the succeed event is: " + event.toString());

    setState(() {
      nextStep(true);

      if (currentStep == 0) {}
    });
  }

  void _onError(Object error) {
    setState(() {
      nextStep(false);
    });
  }

  @override
  Widget build(BuildContext context) {
//    if (currentStep == 0) {
//
//    }
//    if (currentStep == 1) {
//      AndroidPlatform.testWifi();
//    }
//    if (currentStep == 2) {
//      AndroidPlatform.testCall();
//    }
//    if (currentStep == 3) {
//      AndroidPlatform.testCharging();
//    }
//    if (currentStep == 4) {
//      AndroidPlatform.testMicrophone();
//    }
//    if (currentStep == 8) {
//      AndroidPlatform.testVibrate();
//    }

    String function = testStepList[currentStep].deductionPoints;

    switch (function) {
      case 'Wifi':
        FlutterPlatform.testWifi();
        break;
      case 'Gsm Network':
        FlutterPlatform.testCall();
        break;
      case 'Charging Function':
        FlutterPlatform.testCharging();
        break;
      case 'Mic (Recording Test)':
        FlutterPlatform.testMicrophone();
        break;
      case 'Vibrate Function':
        if (!isFinish) {
          FlutterPlatform.testVibrate();
        }
        break;
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
              controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                String function = testStepList[currentStep].deductionPoints;

                if (FlutterPlatform.isAndroid) {
                  switch (function) {
                    case 'Wifi':
                    case 'Charging Function':
                    case 'Mic (Recording Test)':
                      return Center(
                        child: SpinKitRotatingCircle(
                          color: Colors.blue,
                          size: 50.0,
                        ),
                      );
                  }
                } else {
                  switch (function) {
//                    case 'Wifi':
                    case 'Charging Function':
//                    case 'Mic (Recording Test)':
                      return Center(
                        child: SpinKitRotatingCircle(
                          color: Colors.blue,
                          size: 50.0,
                        ),
                      );
                  }
                }




//                if (currentStep == 1 || currentStep == 3 || currentStep == 4) {
//                  return Center(
//                    child: SpinKitRotatingCircle(
//                      color: Colors.blue,
//                      size: 50.0,
//                    ),
//                  );
//                }

                if (currentStep == currentSteps.length - 1) {
                  if (isFinish) {
//                    currentSteps.last = _finishStep(currentSteps.last);

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
                          onPressed: () {
                            print(testResultList.length);

                            print('test result list is $testResultList');

                            String body =
                                "{\"username\":\"admin\",\"password\":\"e10adc3949ba59abbe56e057f20f883e\",\"orderno\":\"$orderNumber\",\"amount\":\"$amount\",\"testinfo\":$testResultList,\"timestamp\":1507628932}";
                            var bodyBytes = Utf8Encoder().convert(body);
                            String requestData = base64.encode(bodyBytes);
                            var paramsJson =
                                "{\"requestdata\":\"$requestData\",\"version\":\"v1.0\"}";

                            String url =
                                "http://192.168.0.110:8085/mm/order/manualtest";

                            http.post(url, body: paramsJson).then((response) {
                              print('Response status: ${response.statusCode}');
                              print('Response body: ${response.body}');
                              var jsonResponse = jsonDecode(response.body);
                              if (response.statusCode == 200 &&
                                  jsonResponse['response'] == 'success') {
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('Upload success')));
                              } else {
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('Upload fail')));
                              }
                            });
                          },
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
      testResultList.add(
        TestResult(
            item: testStepList[currentStep].deductionPoints,
            condition: testStepList[currentStep].conGood),
      );
      currentSteps[currentStep] = _completeStep(currentSteps[currentStep]);
    } else {
      int bad = int.parse(testStepList[currentStep].amountBad);
      print('bad score is $bad');
      amount += bad;
      testResultList.add(
        TestResult(
            item: testStepList[currentStep].deductionPoints,
            condition: testStepList[currentStep].conBad),
      );
      currentSteps[currentStep] = _failStep(currentSteps[currentStep]);
    }

    if (currentStep < currentSteps.length - 1) {
      currentStep++;

      if (currentStep > 1 && currentStep < currentSteps.length + 1 - FlutterPlatform.keepIndex()) {
        controller.animateTo(72.0 * (currentStep - 1),
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      }
      progress = currentStep / currentSteps.length;
      progressPercent = '${(progress * 100).toStringAsFixed(2)}%';
    } else {
      progress = 1.0;
      progressPercent = '100%';
      isFinish = true;
      currentSteps.last = _finishStep(currentSteps.last);
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

  Step _finishStep(Step step) {
    return Step(
      title: step.title,
      content: SizedBox(
        height: 24.0,
      ),
      state: step.state,
    );
  }

  reset() {
    currentSteps = List.of(testSteps);
    currentStep = 0;
    progress = 0;
    progressPercent = '0%';
    controller.animateTo(0.0,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
    isFinish = false;

    testResultList = [];
  }
}
