import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:phone_check/styles.dart';
import 'package:phone_check/android_info.dart';
import 'package:qrcode_reader/qrcode_reader.dart';
import 'test_page.dart';
import 'test_stepper_page.dart';
import 'package:phone_check/android_platform.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:phone_check/data/test_info.dart';

import 'package:phone_check/data/test_steps.dart';

import 'package:phone_check/flutter_platform.dart';
import 'package:phone_check/common/http.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String model = 'Unknown';

  Future<String> _barcodeString;

  BuildContext innerContext;

  bool isValid = false;

  var image;

  var startBtnImage = Image.asset(
    'assets/images/start_test_btn_en.png',
    width: 220.0,
  );

  var qrBtnImage = Image.asset(
    'assets/images/start_qr_btn.png',
    width: 220.0,
  );

  bool validate() {
    return isValid;
  }

  @override
  void initState() {
    FlutterPlatform.checkPlatform();
    image = qrBtnImage;
    FlutterPlatform.getDeviceMode().then((result) {
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
          Container(
            color: Color.fromARGB(255, 82, 191, 46),
          ),
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

                    if (innerContext == null) {
                      innerContext = context;
                    }

                    print('snapshot.data : ${snapshot.data}');
                    if (snapshot.data != null && !isValid) {
                      getTestContent(snapshot.data);
                    }

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
                onPressed: () async {
                  print('flat button is pressed.');
                  if (isValid == true) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return TestStepperPage();
                    }));
                  } else {
                    try {
                      final result = await InternetAddress.lookup('baidu.com');
                      if (result.isNotEmpty &&
                          result[0].rawAddress.isNotEmpty) {
                        var barcodeResult = null;
                        if (FlutterPlatform.isAndroid) {
                          barcodeResult = new QRCodeReader()
                              .setAutoFocusIntervalInMs(200)
                              .setForceAutoFocus(true)
                              .setTorchEnabled(true)
                              .setHandlePermissions(true)
                              .setExecuteAfterPermissionGranted(true)
                              .scan();
                        } else {
                          print('scan ios');
                          barcodeResult = new QRCodeReader().scan();
                          print('scan ios finished');
                        }
                        print('after bar');
                        setState(() {
                          _barcodeString = barcodeResult;
                        });
                      }
                    } catch (e) {
                      print(e);
                      Scaffold.of(innerContext).showSnackBar(SnackBar(
                        content: Text(
                          'Internet error, please check your Wi-Fi or GPRS.',
                        ),
                        backgroundColor: Colors.red,
                      ));
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getTestContent(value) async {
    orderNumber = value;

    print("value is $value");

    String body =
        "{\"username\":\"admin\",\"password\":\"e10adc3949ba59abbe56e057f20f883e\",\"orderno\":\"$orderNumber\",\"timestamp\":1507628932}";
    var bodyBytes = Utf8Encoder().convert(body);
    String requestData = base64.encode(bodyBytes);
    print(requestData);
    var paramsJson = "{\"requestdata\":\"$requestData\",\"version\":\"v1.0\"}";

    String domain = Domain().value;

    String url = "$domain:8085/mm/order/manualtest?params=$paramsJson";

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var estAmount = jsonResponse['EstAmount'];
//      print("response json is $jsonResponse");

      print("estAmount is $estAmount");

      estAmountInt = int.parse(estAmount);

      print('the int estAmount is $estAmountInt');

      JsonEncoder encoder = JsonEncoder.withIndent('  ');
      String pretty = encoder.convert(jsonResponse);
      print(pretty);

      if (jsonResponse['response'].toString() == "success") {
        var testInfo = jsonResponse['testinfo'];

        var list = testInfo as List;
        List<TestStep> stepList =
            list.map((i) => TestStep.fromJson(i)).toList();

        int length = list.length;

        print('length is: $length');

        if (length > 0) {
          List<Step> steps = [];

          for (var item in stepList) {
            print(item.deductionPoints);

            steps.add(Step(
              title: Text(item.deductionPoints),
              content: Text('Is ${item.deductionPoints} ${item.conGood} ?'),
            ));
          }

          testSteps = steps;
          testStepList = stepList;

          isValid = true;
        } else {
          print('empty snack bar shown......');
          Scaffold.of(innerContext)
              .showSnackBar(SnackBar(content: Text('Empty Testing Item')));
          isValid = false;
        }
      } else {
        Scaffold.of(innerContext)
            .showSnackBar(SnackBar(content: Text('Response Fail')));
        isValid = false;
      }
    } else {
      Scaffold.of(innerContext)
          .showSnackBar(SnackBar(content: Text('Response Fail')));
      isValid = false;
      print(response.statusCode);
    }
    if (validate()) {
      setState(() {
        image = startBtnImage;
      });
    } else {
//      setState(() {
//        image = qrBtnImage;
//      });
    }
  }
}
