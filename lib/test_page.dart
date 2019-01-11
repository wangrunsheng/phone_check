import 'package:flutter/material.dart';
import 'package:timeline/model/timeline_model.dart';
import 'package:timeline/timeline.dart';

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
      body: Center(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.asset('assets/images/testing.gif'),
                Center(
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
                )
              ],
            ),
            Container(
              height: 450.0,
              child: TimelineComponent(
                timelineList: list,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
