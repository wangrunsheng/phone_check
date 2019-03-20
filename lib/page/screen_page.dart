import 'package:flutter/material.dart';
import 'package:phone_check/styles.dart';

class ScreenPage extends StatefulWidget {
  @override
  _ScreenPageState createState() => _ScreenPageState();
}

class _ScreenPageState extends State<ScreenPage> {
  var rgb = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.white,
    Colors.grey,
    Colors.black
  ];

  int currentIndex = 0;

  TextStyle clickStyle = Styles.textWhiteLarge;

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
                if (currentIndex < 5) {
                  currentIndex = currentIndex + 1;
                  if (currentIndex == 3) {
                    clickStyle = Styles.textBlackLarge;
                  } else {
                    clickStyle = Styles.textWhiteLarge;
                  }
                } else {
                  Navigator.pop(context);
                }
              });
            },
            child: Text(
              'Click',
              style: clickStyle,
            ),
          ),
        ),
      ),
      onWillPop: () {
        print('do not go back.');
      },
    );
  }
}
