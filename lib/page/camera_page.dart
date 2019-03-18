import 'package:flutter/material.dart';
import 'test_page.dart';
import 'package:phone_check/styles.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:phone_check/main.dart';

class CameraPage extends StatefulWidget {
  final String direction;

  CameraPage({@required this.direction});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController controller;

  @override
  void initState() {
    super.initState();
    print('cameras number: ${cameras.length}');

    switch (widget.direction) {
      case 'front':
        controller = CameraController(cameras[1], ResolutionPreset.high);
        break;
      case 'back':
        controller = CameraController(cameras[0], ResolutionPreset.high);
        break;
    }
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print('camera direction: ${widget.direction}');
    if (!controller.value.isInitialized) {
      return Container();
    }
    return WillPopScope(
      onWillPop: () {
        print('camera will not pop');
      },
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Stack(
          children: <Widget>[
            CameraPreview(controller),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: FlatButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text('Go Back'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
