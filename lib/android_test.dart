//import 'package:vibrate/vibrate.dart';

import 'package:vibration/vibration.dart';
import 'package:flutter/services.dart';



class AndroidTool {
  static const EventChannel _eventChannel = EventChannel('wang.runsheng.test/charging');

static listenCharging(Function onEvent, Function onError) {
  _eventChannel.receiveBroadcastStream().listen(onEvent, onError: onError);
}

  static vibrate() {
    print('trying to vibrate the android phone.');
    //Vibrate.vibrate();
    Vibration.vibrate(duration: 1000);
  }

  
}