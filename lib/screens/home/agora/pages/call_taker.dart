import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livq/screens/home/agora/pages/thank_you.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livq/screens/home/agora/widgets/call_common.dart';
import 'package:livq/screens/home/buttons/animated_radial_menu.dart';
import 'package:livq/screens/navigation/bottom_navigation.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/widgets/firebaseAuth.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../config.dart';
import '../widgets/pie_chart.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

class CallPage_taker extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String? channelName;
  const CallPage_taker({
    Key? key,
    this.channelName,
  }) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage_taker> {
  Call_common _common = Call_common();
  AuthClass _auth = AuthClass();

  bool _helperIn = false;

  //bool isLoading = false;

  CountDownController _controller = CountDownController();
  int _duration = 90;
  int getTime = 90;

  Color sendColor = AppColors.primaryColor;

  // Clean up the resources when you leave
  @override
  void dispose() async {
    await _common.agoraEngine.leaveChannel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _common.uid = 1;

    // Set up an instance of Agora engine
    setupVideoSDKEngine();
  }

  Future<void> setupVideoSDKEngine() async {
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    _common.agoraEngine = createAgoraRtcEngine();
    await _common.agoraEngine.initialize(const RtcEngineContext(appId: appId));

    await _common.agoraEngine.enableVideo();
    await _common.agoraEngine.startPreview();

    await fetchToken(_common.uid, widget.channelName!, _common.tokenRole);

    DataStreamConfig config =
        await DataStreamConfig(ordered: false, syncWithAudio: false);
    _common.streamId = await _common.agoraEngine.createDataStream(config);
    // Register the event handler
    _common.agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          Get.snackbar(
              "Local user uid:${connection.localUid} joined the channel",
              "onJoinChannelSuccess");
          setState(() {
            _common.isJoined = true;
          });
          Get.snackbar("join 성공", "타이머 시작되어야 함.");
          _controller.start();
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          Get.snackbar(
              "Remote user uid:$remoteUid joined the channel", "remote joined");
          setState(() {
            _common.remoteUid = remoteUid;
            // print("_remoteUid $_remoteUid");
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          //여기에 자동으로 나갈 수 있게 하기
          Get.snackbar(
              "Remote user uid:$remoteUid left the channel", "offline");

          setState(() {
            _common.isJoined = false;
            _common.remoteUid = null;
          });
          _common.agoraEngine.leaveChannel();
          Get.offAll(() => ThankYouPage());
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          // showMessage('Token expiring');
          _common.isTokenExpiring = true;
          setState(() {
            // fetch a new token when the current token is about to expire
            fetchToken(_common.uid, widget.channelName!, _common.tokenRole);
          });
        },
        onStreamMessage:
            (connection, remoteUid, streamId, data, length, sentTs) {
          // print("get data ${String.fromCharCodes(data)}");
          // Get.snackbar("get data", String.fromCharCodes(data));

          late String first;
          late String second;
          late double d1;
          late double d2;
          String _coordinates = String.fromCharCodes(data);
          if (_coordinates.compareTo('grey') == 0) {
            setState(() {
              sendColor = AppColors.grey[50]!;
            });
          } else if (_coordinates.compareTo('primary') == 0) {
            setState(() {
              sendColor = AppColors.primaryColor;
            });
          } else if (_coordinates.compareTo('secondary') == 0) {
            setState(() {
              sendColor = AppColors.secondaryColor;
            });
          } else if (_coordinates.compareTo('red') == 0) {
            setState(() {
              sendColor = Colors.red;
            });
          } else {
            _common.subtract = (MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).size.width / 3 * 4)) /
                2;
            first = _coordinates.substring(0, _coordinates.indexOf(' '));
            second = _coordinates.substring(
                _coordinates.indexOf(' '), _coordinates.indexOf('a'));
            d1 = double.parse(first);
            d2 = double.parse(second);
            _common.change = Offset(
                d1 * MediaQuery.of(context).size.width,
                d2 * MediaQuery.of(context).size.width / 3 * 4 +
                    _common.subtract);
            setState(() {
              _common.value = 0;
              _common.timer =
                  Timer.periodic(const Duration(milliseconds: 3), (t) {
                setState(() {
                  if (_common.value < 100) {
                    _common.value++;
                  } else {
                    _common.timer.cancel();
                  }
                });
              });
            });
          }
        },
      ),
    );
  }

  Future<void> fetchToken(int uid, String channelName, int tokenRole) async {
    // Prepare the Url
    String url =
        '$serverUrl/rtc/$channelName/${tokenRole.toString()}/uid/${uid.toString()}?expiry=${_common.tokenExpireTime.toString()}';

    print("url : $url");

    // Send the request
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      Map<String, dynamic> json = jsonDecode(response.body);
      String newToken = json['rtcToken'];
      debugPrint('Token Received: $newToken');
      // Use the token to join a channel or renew an expiring token
      // print("newtoken : $newToken");
      setToken(newToken, channelName);
    } else {
      // If the server did not return an OK response,
      // then throw an exception.
      throw Exception(
          'Failed to fetch a token. Make sure that your server URL is valid');
    }
  }

  void setToken(String newToken, String channelName) async {
    _common.token = newToken;

    if (_common.isTokenExpiring) {
      // Renew the token
      _common.agoraEngine.renewToken(_common.token);
      _common.isTokenExpiring = false;
      // showMessage("Token renewed");
    } else {
      // Join a channel.
      // showMessage("Token received, joining a channel...");

      ChannelMediaOptions options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      );

      await _common.agoraEngine.joinChannel(
        token: _common.token,
        channelId: channelName,
        options: options,
        uid: _common.uid,
      );
    }
  }

  Widget _turnoffcamera() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage("https://i.ibb.co/nsVhXLq/black-background.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black, BlendMode.dstATop),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "카메라가 꺼져있습니다",
              style: TextStyle(
                color: Color(0xffffffff),
                fontSize: 16,
              ),
            ),
            Text(
              "Camera is off",
              style: TextStyle(
                color: Color(0xffffffff),
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Helper와 음성으로 도움을 받으세요!",
              style: TextStyle(
                color: Color(0xff979797),
                fontSize: 14,
              ),
            ),
            Text(
              "Getting a help with the voice",
              style: TextStyle(
                color: Color(0xff979797),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Toolbar layout
  Widget _toolbar() {
    //if (widget.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              _common.videoOnOff ? Icons.videocam_off : Icons.videocam,
              color: _common.videoOnOff ? Colors.white : AppColors.primaryColor,
              size: 45.h,
            ),
            shape: const CircleBorder(),
            elevation: 4.0,
            fillColor: _common.videoOnOff ? AppColors.grey[700] : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          SizedBox(
            width: 33.w,
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 45.h,
            ),
            shape: const CircleBorder(),
            elevation: 4.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          SizedBox(
            width: 33.w,
          ),
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              _common.muted ? Icons.mic_off : Icons.mic,
              color: _common.muted ? Colors.white : AppColors.primaryColor,
              size: 45.h,
            ),
            shape: const CircleBorder(),
            elevation: 4.0,
            fillColor: _common.muted ? AppColors.grey[700] : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
        ],
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    setState(() {
      _common.isJoined = false;
      _common.remoteUid = null;
    });
    _common.agoraEngine.leaveChannel();
    _common.agoraEngine.sendStreamMessage(
        streamId: _common.streamId!,
        data: Uint8List.fromList("end".codeUnits),
        length: Uint8List.fromList("end".codeUnits).length);
    Get.offAll(() => ThankYouPage());
  }

  void _onToggleMute() {
    setState(() {
      _common.muted = !_common.muted;
    });
    _common.agoraEngine.muteLocalAudioStream(_common.muted);
  }

  void _onSwitchCamera() {
    _common.agoraEngine.sendStreamMessage(
        streamId: _common.streamId!,
        data: Uint8List.fromList("onoffVideo".codeUnits),
        length: Uint8List.fromList("onoffVideo".codeUnits).length);
    setState(() {
      _common.videoOnOff = !_common.videoOnOff;
    });
  }

  Widget circleDrawing(BuildContext context) {
    // location = Offset(MediaQuery.of(context).size.width / 2,
    //     MediaQuery.of(context).size.height / 2);
    return Stack(
      children: [
        CustomPaint(
          size: Size(Config.screenWidth! * 0.2, Config.screenWidth! * 0.2),
          painter: PieChart(
            percentage: _common.value,
            location: _common.change,
            getcolor: sendColor,
          ),
        ),
      ],
    );
  }

  Widget voiceOff(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50.h,
          ),
          const Text(
            "음성이 꺼져 있습니다.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "Voice is off",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget waitingHelper(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  SizedBox(width: ScreenUtil().setWidth(20)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '남은 매칭시간',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            color: Color(0xFFF9A825)),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      CircularCountDownTimer(
                        // Countdown duration in Seconds.
                        duration: _duration,

                        // Countdown initial elapsed Duration in Seconds.
                        initialDuration: 0,

                        // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
                        controller: _controller,

                        // Width of the Countdown Widget.
                        width: 50.w,

                        // Height of the Countdown Widget.
                        height: 50.w,

                        // Ring Color for Countdown Widget.
                        ringColor: AppColors.primaryColor[200]!, //200

                        // Ring Gradient for Countdown Widget.
                        ringGradient: null,

                        // Filling Color for Countdown Widget.
                        fillColor: AppColors.primaryColor[600]!, //600

                        // Filling Gradient for Countdown Widget.
                        fillGradient: null,

                        // Background Color for Countdown Widget.
                        backgroundColor: AppColors.primaryColor, //primary

                        // Background Gradient for Countdown Widget.
                        backgroundGradient: null,

                        // Border Thickness of the Countdown Ring.
                        strokeWidth: 20.0,

                        // Begin and end contours with a flat edge and no extension.
                        strokeCap: StrokeCap.round,

                        // Text Style for Countdown Text.
                        textStyle: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),

                        // Format for the Countdown Text.
                        textFormat: CountdownTextFormat.S,

                        // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
                        isReverse: true,

                        // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
                        isReverseAnimation: true,

                        // Handles visibility of the Countdown Text.
                        isTimerTextShown: true,

                        // Handles the timer start.
                        autoStart: false,

                        // This Callback will execute when the Countdown Ends.
                        onComplete: () {
                          // Here, do whatever you want
                          Get.snackbar("다시 연결하세요!", "다른이가 도와줄 거에요!",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.primaryColor,
                              colorText: Colors.white);
                          Get.find<ButtonController>().changetrue();
                          Get.offAll(BottomNavigation());
                        },
                      ),
                    ],
                  ),
                  SizedBox(width: ScreenUtil().setWidth(173)),
                ],
              ),
              SizedBox(height: ScreenUtil().setHeight(140)),
              Container(
                height: ScreenUtil().setHeight(91.04),
                width: ScreenUtil().setWidth(63),
                child: SvgPicture.asset(
                  'assets/liveQ_logo.svg',
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(30)),
              Icon(Icons.circle,
                  size: ScreenUtil().setHeight(8),
                  color: getTime % 3 == 0
                      ? AppColors.primaryColor[400]!
                      : Colors.blueAccent),
              SizedBox(height: ScreenUtil().setHeight(16)),
              Icon(Icons.circle,
                  size: ScreenUtil().setHeight(8),
                  color: AppColors.primaryColor[600]!),
              SizedBox(height: ScreenUtil().setHeight(16)),
              Icon(Icons.circle,
                  size: ScreenUtil().setHeight(8),
                  color: AppColors.primaryColor),
              Column(
                children: [
                  Column(children: [
                    SizedBox(height: ScreenUtil().setHeight(18)),
                    Text(
                      '답변자 매칭 중이에요',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(18),
                          color: Color(0xFF212529)),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(16)),
                    Text(
                      '매칭이 완료되면 실시간 화면',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          color: Color(0xFF212529)),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(1.3)),
                    Text(
                      '공유를 통해 질문을 할 수 있어요',
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(14),
                          color: Color(0xFF212529)),
                    ),
                  ]),

                  SizedBox(height: ScreenUtil().setHeight(144)),
                  SizedBox(
                    height: ScreenUtil().setHeight(49),
                    width: ScreenUtil().setHeight(287),
                    child: ElevatedButton(
                      onPressed: () {
                        _controller.resume();
                        FirebaseFirestore.instance
                            .collection('videoCall')
                            .doc(_auth.firebaseUser!.uid)
                            .delete();
                        Get.find<ButtonController>().changetrue();
                        Get.offAll(BottomNavigation());
                      },
                      child: Text(
                        '매칭 취소하기',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(14),
                            color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffE9ECEF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(33),
                        ),
                      ),
                    ),
                  ),

                  //SizedBox(height: ScreenUtil().setHeight(50)),
                ],
              ),
            ]),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _common.videoOnOff
          ? Center(
              child: Stack(
                children: <Widget>[
                  _turnoffcamera(),
                  // if (heart == true) heartPop(),
                  // _panel(),
                  _common.muted ? voiceOff(context) : Container(),
                  _toolbar(),
                ],
              ),
            )
          // : _common.remoteUid != null
          //     ?
          : Center(
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width / 3 * 4,
                      child: _localPreview(),
                    ),
                  ),
                  // if (heart == true) heartPop(),
                  // _panel(),
                  _common.muted ? voiceOff(context) : Container(),
                  circleDrawing(context),
                  _toolbar(),
                ],
              ),
            ),
      // : waitingHelper(context),
    );
  }

// Display local video preview
  Widget _localPreview() {
    if (_common.isJoined) {
      //uid가 0으로 되어야만 자기 자신이 나타난다.
      _common.agoraEngine.switchCamera();
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _common.agoraEngine,
          canvas: VideoCanvas(uid: 0),
        ),
      );
    } else {
      return const Text(
        'Join a channel',
        textAlign: TextAlign.center,
      );
    }
  }

// Display remote user's video
  Widget _remoteVideo() {
    if (_common.remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _common.agoraEngine,
          canvas: VideoCanvas(uid: _common.remoteUid),
          connection: RtcConnection(channelId: widget.channelName),
        ),
      );
    } else {
      String msg = '';
      if (_common.isJoined) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }
}
