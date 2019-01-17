import 'package:flutter/material.dart';
import 'package:timeline/model/timeline_model.dart';
import 'package:timeline/timeline.dart';
import 'package:timeline_flow/timeline_flow.dart';
import 'android_info.dart';

import 'styles.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final List<TimelineModel> list = [
    TimelineModel(id: "1", description: "Test 1", title: "Test 1"),
    TimelineModel(id: "2", description: "Test 2", title: "Test 2"),
    TimelineModel(id: "3", description: "Test 3", title: "Test 3"),
    TimelineModel(id: "4", description: "Test 4", title: "Test 4"),
    TimelineModel(id: "5", description: "Test 5", title: "Test 5"),
    TimelineModel(id: "6", description: "Test 6", title: "Test 6"),
    TimelineModel(id: "7", description: "Test 7", title: "Test 7"),
    TimelineModel(id: "8", description: "Test 8", title: "Test 8")
  ];

  int current_step = 0;

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
      state: StepState.editing,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Testing'),
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
      body: NestedScrollView(
        physics: NeverScrollableScrollPhysics(),
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
                          'Testing',
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
                        value: 0.05,
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
              test_steps[step] = _completeStep(test_steps[step]);
            });
          },
          onStepCancel: () {},
          onStepContinue: () {
            setState(() {
              current_step++;
            });
          },
        ),
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
