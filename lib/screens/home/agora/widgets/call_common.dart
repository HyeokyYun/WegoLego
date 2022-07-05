import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';

class Call_common {
  //for agora variable
  final users = <int>[];
  final infoStrings = <String>[];
  bool muted = false;
  bool videoOnOff = false;
  late RtcEngine engine;
  int? streamId;
  late Offset change;
  bool heart = false;

  //for drawing circle
  late Timer timer;
  final bool isPlaying = false;
  var value = 0;
  Offset? location;
  late double subtract;
}
