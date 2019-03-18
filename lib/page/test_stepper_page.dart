import 'package:flutter/material.dart';

import 'package:phone_check/styles.dart';
import 'camera_page.dart';
import 'package:phone_check/data/test_steps.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:http/http.dart' as http;

import 'package:phone_check/data/test_info.dart';

import 'dart:convert';

import 'package:phone_check/flutter_platform.dart';

import 'screen_page.dart';
import 'camera_page.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:phone_check/common/http.dart';

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
      case 'Lcd Display':
        break;
      case 'Bluetooth':
        FlutterPlatform.testBluetooth();
        break;
      case 'Gps Function':
        FlutterPlatform.testGsp();
        break;
      case 'Infra Red Test':
        FlutterPlatform.testInfraRed();
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
                    case 'Bluetooth':
                    case 'Gps Function':
                    case 'Infra Red Test':
                      return Center(
                        child: SpinKitRotatingCircle(
                          color: Colors.blue,
                          size: 50.0,
                        ),
                      );
                      break;
                    case 'Lcd Display':
//                      Navigator.push(context,
//                          MaterialPageRoute(builder: (BuildContext context) {
//                        return ScreenPage();
//                      }));
                      break;
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

                            String domain = Domain().value;

                            String url = "$domain:8085/mm/order/manualtest";

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
    if (currentStep < currentSteps.length - 1) {
      String function = testStepList[currentStep + 1].deductionPoints;
      print('next function is $function');

      if (function == 'Lcd Display') {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ScreenPage();
        }));
      }

      if (function == 'Front Camera Test') {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return CameraPage(
            direction: 'front',
          );
        }));
      }

      if (function == 'Rear Camera Test') {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return CameraPage(
            direction: 'back',
          );
        }));
      }

      if (function == 'Headset Test') {
        _showHeadsetTestDialog();
      }

      if (function == 'Buzzer/ Speakerphone Test') {
        _assetsAudioPlayer.open(music);
        _assetsAudioPlayer.play();
        _showSpeakerTestDialog();
      }

      if (function == 'Vibrate Function') {
        _showVibrateTestDialog();
      }

      if (function == 'Fingerprint Test') {
        _showFingerprintTestDialog();
      }

      if (function == 'Receiver Test') {
        if (FlutterPlatform.isAndroid) {
          _showReceiverTestDialog();
        }

      }
    }

    if (isSuccess) {
      _assetsAudioPlayer.open(pass);
      _assetsAudioPlayer.play();
      testResultList.add(
        TestResult(
            item: testStepList[currentStep].deductionPoints,
            condition: testStepList[currentStep].conGood),
      );
      currentSteps[currentStep] = _completeStep(currentSteps[currentStep]);
    } else {
      _assetsAudioPlayer.open(fail);
      _assetsAudioPlayer.play();
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

      if (currentStep > 1 &&
          currentStep < currentSteps.length + 1 - FlutterPlatform.keepIndex()) {
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

  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  final AssetsAudio pass = AssetsAudio(
    asset: 'wpass.wav',
    folder: 'assets/audios',
  );

  final AssetsAudio fail = AssetsAudio(
    asset: 'wfail.wav',
    folder: 'assets/audios',
  );

  final AssetsAudio music = AssetsAudio(
    asset: 'wmusic.wav',
    folder: 'assets/audios',
  );

  Future<void> _showHeadsetTestDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              print('dialog not pop.');
            },
            child: AlertDialog(
              title: Text('Headset Test'),
              content: Container(
                height: 150.0,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text('Play music after plug in a Headset'),
                      Container(
                        height: 100.0,
                        child: Center(
                          child: FlatButton.icon(
                              onPressed: () {
                                print('play music');
                                _assetsAudioPlayer.open(music);
                                _assetsAudioPlayer.play();
                              },
                              icon: Icon(
                                Icons.play_arrow,
                                size: 50.0,
                                color: Colors.blue,
                              ),
                              label: Text('Play')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    _assetsAudioPlayer.stop();
                    Navigator.pop(context);
                  },
                  child: Text('Go Back'),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _showSpeakerTestDialog() async {
    _assetsAudioPlayer.open(music);
    _assetsAudioPlayer.play();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              print('dialog not pop.');
            },
            child: AlertDialog(
              title: Text('Buzzer/Speakerphone Test'),
              content: Container(
                height: 150.0,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text('Click to play music'),
                      Container(
                        height: 100.0,
                        child: Center(
                          child: FlatButton.icon(
                              onPressed: () {
                                print('play music');
                                _assetsAudioPlayer.open(music);
                                _assetsAudioPlayer.play();
                              },
                              icon: Icon(
                                Icons.play_arrow,
                                size: 50.0,
                                color: Colors.blue,
                              ),
                              label: Text('Play')),

//                          SpinKitWave(
//                            color: Colors.blue,
//                            size: 50.0,
//                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    _assetsAudioPlayer.stop();
                    Navigator.pop(context);
                  },
                  child: Text('Go Back'),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _showVibrateTestDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              print('dialog not pop.');
            },
            child: AlertDialog(
              title: Text('Vibrate Function'),
              content: Container(
                height: 150.0,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text('Phone is vibrating...'),
                      Container(
                        height: 100.0,
                        child: Center(
                          child: SpinKitRipple(
                            color: Colors.blue,
                            size: 50.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Go Back'),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _showFingerprintTestDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              print('dialog not pop.');
            },
            child: AlertDialog(
              title: Text('Fingerprint Test'),
              content: Container(
                height: 150.0,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text('Please set fingerprint first'),
                      Container(
                        height: 100.0,
                        child: Center(
                          child: Icon(
                            Icons.fingerprint,
                            size: 50.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Go Back'),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _showReceiverTestDialog() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              print('dialog not pop.');
            },
            child: AlertDialog(
              title: Text('Receiver Test'),
              content: Container(
                height: 150.0,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text('Play music and put the phone by your ear'),
                      Container(
                        height: 100.0,
                        child: Center(
                          child: FlatButton.icon(
                              onPressed: () {
                                print('play music');
                                FlutterPlatform.switchToReceiver();
                                _assetsAudioPlayer.open(music);
                                _assetsAudioPlayer.play();
                              },
                              icon: Icon(
                                Icons.play_arrow,
                                size: 50.0,
                                color: Colors.blue,
                              ),
                              label: Text('Play')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    _assetsAudioPlayer.stop();
                    FlutterPlatform.switchToSpeaker();
                    Navigator.pop(context);
                  },
                  child: Text('Go Back'),
                ),
              ],
            ),
          );
        });
  }
}
