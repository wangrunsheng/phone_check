import 'package:flutter/material.dart';
import 'test_page.dart';
import 'package:phone_check/styles.dart';

class CameraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: (){},
          child: const Text(
            'OK',
            style: Styles.textWhite,
          ),
          color: Colors.green,
        ),
      ),
    );
  }
}
