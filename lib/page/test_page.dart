import 'package:flutter/material.dart';
import 'package:phone_check/android_info.dart';

import 'package:phone_check/styles.dart';
import 'camera_page.dart';
import 'package:phone_check/data/test_steps.dart';

import 'package:phone_check/android_test.dart';

const String font_camera_hero_tag = 'FontCamera';
const String controls_hero_tag = "ControlsButton";
const String left_controls_hero_tag = "LeftControlsButton";
const String right_controls_hero_tag = "RightControlsButton";

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int current_step = 0;

  List<Step> current_steps = test_steps;

  double progress = 0.0;
  String progressPercent = '0%';

  Future<void> _askedToLead() async {
    switch (await showDialog<Department>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select assignment'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {},
                child: const Text('Treasuty department'),
              ),
              SimpleDialogOption(
                onPressed: () {},
                child: const Text('State department'),
              ),
            ],
          );
        })) {
      case Department.treasury:
        break;
      case Department.state:
        break;
    }
  }

  Future<void> _neverSatisfied() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Rewind and remember'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('You will never be satisfied.'),
                  Text('You\'re like me. I\'m never satisfied.'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Regret'),
                onPressed: () {},
              ),
              FlatButton(
                child: Text('Come'),
                onPressed: () {
                  AndroidInfo.getMemorySize().then((size) {
                    print('Android Internal Memory Size: $size');
                  });
                },
              ),
            ],
          );
        });
  }

  String _chargingStatus = 'Battery status: unkown.';

  List<GlobalKey> _keys;

  @override
  void initState() {
    super.initState();
    AndroidTool.listenCharging(_onEvent, _onError);

    _keys = List<GlobalKey>.generate(
      current_steps.length,
      (int i) => GlobalKey(),
    );
  }

  void _onEvent(Object event) {
    setState(() {
      _chargingStatus =
          "Battery status: ${event == 'charging' ? '' : 'dis'}charging.";
      current_step++;
    });
  }

  void _onError(Object error) {
    setState(() {
      _chargingStatus = 'Battery status: unknown.';
      current_step++;
    });
  }

  @override
  Widget build(BuildContext context) {
    runTestFunction(current_step);
    return Scaffold(
      appBar: AppBar(
        title: Text(_chargingStatus),
        elevation: 0.0,
        titleSpacing: 0.0,
        backgroundColor: Color.fromARGB(255, 73, 170, 249),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                print('retest');
                current_steps = test_steps;
                current_step = 0;
              });
            },
          ),
        ],
      ),
      body: NestedScrollView(
        controller: ScrollController(),
        headerSliverBuilder: (BuildContext context, bool isInnerBoxScrolled) {
          return [
            SliverList(
              delegate: SliverChildListDelegate([
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
                          onPressed: () {
                            // _askedToLead();
                            _neverSatisfied();
                          },
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
              ]),
            ),
          ];
        },
        body: Stepper(
          controlsBuilder: (BuildContext context,
              {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
            //  print('current step: $current_step');

            if (current_step == 0) {
              return Center(
                child: SizedBox(
                  height: 20.0,
                  child: Icon(Icons.refresh),
                ),
              );
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
          currentStep: this.current_step,
          steps: current_steps,
          type: StepperType.vertical,
          onStepTapped: (step) {
            // setState(() {
            //   current_step = step;
            //   progress = (step + 1) / 15;
            //   progressPercent = '${(progress * 100).toStringAsFixed(2)}%';
            //   test_steps[step] = _completeStep(test_steps[step]);
            // });

            // if (step == 9) {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (BuildContext context) {
            //       return CameraPage();
            //     }),
            //   );
            // }
          },
          onStepCancel: () {
            setState(() {
              current_steps[current_step] = _failStep(test_steps[current_step]);
              current_step++;
              runTestFunction(current_step);
            });
          },
          onStepContinue: () {
            setState(() {
              current_steps[current_step] =
                  _completeStep(test_steps[current_step]);
              current_step++;
              runTestFunction(current_step);
            });

            Scrollable.ensureVisible(
              _keys[current_step].currentContext,
            );
          },
        ),
      ),
    );
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

_testFunction(Function f) => f;

enum Department {
  treasury,
  state,
}
