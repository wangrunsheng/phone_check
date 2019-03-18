import 'package:flutter/material.dart';
import 'package:phone_check/styles.dart';

class ScreenPage extends StatefulWidget {
  @override
  _ScreenPageState createState() => _ScreenPageState();
}

class _ScreenPageState extends State<ScreenPage> {
  var rgb = [Colors.red, Colors.green, Colors.blue];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Container(
        color: rgb[currentIndex],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlatButton(
            onPressed: () {
              setState(() {
                if (currentIndex < 2) {
                  currentIndex = currentIndex + 1;
                } else {
                  Navigator.pop(context);
                }
              });
            },
            child: Text('Click',style: Styles.textWhiteLarge,),
          ),
        ),
      ),
      onWillPop: () {
        print('do not go back.');
      },
    );
  }
}
