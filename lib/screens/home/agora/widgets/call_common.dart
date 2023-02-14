import 'dart:async';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const String appId = '3314a275f7114db58caaadebfab9679d';
const String serverUrl =
    "https://agora-token-service-production-a63e.up.railway.app";

class Call_common {
  //agora settings

  late String token;

  //firebase

  //for agora variable
  late RtcEngine agoraEngine;
  bool muted = false;
  bool videoOnOff = false;
  int? streamId;
  bool isJoined = false;
  int? remoteUid;
  bool isTokenExpiring = false;
  late int uid;
  int tokenRole = 1; // use 1 for Host/Broadcaster, 2 for Subscriber/Audience
  int tokenExpireTime = 120; // Expire time in Seconds.
  Offset change = Offset(0, 0);

  // //for agora variable
  // final users = <int>[];
  // final infoStrings = <String>[];
  // bool muted = false;
  //
  // late RtcEngine engine;

  // bool heart = false;

  //for drawing circle
  late Timer timer;
  final bool isPlaying = false;
  var value = 0;
  Offset? location;
  late double subtract;

  String getAppId() {
    return appId;
  }
}
