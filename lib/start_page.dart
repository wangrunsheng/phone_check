import 'package:flutter/material.dart';
import 'dart:async';
import 'styles.dart';
import 'android_info.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'test_page.dart';
import 'android_test.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String model = 'Unknown';

  Future<String> _barcodeString;

  bool isValid = false;

  var image;

  var startBtnImage = Image.asset(
    'assets/images/start_test_btn.png',
    width: 220.0,
  );

  var qrBtnImage = Image.asset(
    'assets/images/start_qr_btn.png',
    width: 220.0,
  );

  bool validate() {
    return isValid = !isValid;
  }

  @override
  void initState() {
    image = qrBtnImage;
    AndroidInfo.getDeviceInfo().then((result) {
      setState(() {
        this.model = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('build home page');

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset('assets/images/start_test_gif.gif'),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Testing Model:',
                  style: Styles.testModelTitleTextStyle,
                ),
                Text(
                  model,
                  style: Styles.testModelTextStyle,
                ),
                FutureBuilder<String>(
                  future: _barcodeString,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    print('========isValid is : $isValid');
                    return new Text(snapshot.data != null ? snapshot.data : '');
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 70.0,
              ),
              child: FlatButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: image,
                onPressed: () {
                  print('flat button is pressed.');
                  //  AndroidInfo.showToast('Toast from Android');
                  // setState(() {
                  //   image = startBtnImage;
                  // });
                  if (isValid == true) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return TestPage();
                    }));
                  } else {
                    setState(() {
                      _barcodeString = new QRCodeReader()
                          .setAutoFocusIntervalInMs(200)
                          .setForceAutoFocus(true)
                          .setTorchEnabled(true)
                          .setHandlePermissions(true)
                          .setExecuteAfterPermissionGranted(true)
                          .scan();
                    });
                  }
                  if (validate()) {
                    image = startBtnImage;
                  } else {
                    image = qrBtnImage;
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}