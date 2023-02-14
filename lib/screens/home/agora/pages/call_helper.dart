import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livq/screens/home/agora/utils/settings.dart';
import 'package:livq/screens/home/agora/widgets/call_common.dart';
import 'package:livq/screens/home/buttons/animated_radial_menu.dart';
import 'package:livq/screens/navigation/bottom_navigation.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/widgets/firebaseAuth.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../config.dart';
import '../widgets/pie_chart.dart';
import '../widgets/heart.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:http/http.dart' as http;

const String appId = '3314a275f7114db58caaadebfab9679d';

class CallPage_helper extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String? channelName;
  const CallPage_helper({Key? key, this.channelName}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage_helper> {
  Call_common _common = Call_common();
  AuthClass _auth = AuthClass();

  int helper_one = 0;
  late String uid_check;
  int count = 1;
  bool get_uid = true;
  bool pass_check = true;

  Offset? location;
  late String getdetails;
  late double nomalizationDx;
  late double nomalizationDy;
  Color sendColor = AppColors.primaryColor;

  @override
  void dispose() async {
    await _common.agoraEngine.leaveChannel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _common.uid = 2;

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
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          Get.snackbar(
              "Remote user uid:$remoteUid joined the channel", "remote joined");
          setState(() {
            _common.isJoined = false;
            _common.remoteUid = null;
          });
          // Get.back();
          FirebaseFirestore.instance
              .collection('users')
              .doc(_auth.uid)
              .update({'help': FieldValue.increment(1)});
          Get.offAll(() => BottomNavigation());
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          //여기에 자동으로 나갈 수 있게 하기
          Get.snackbar(
              "Remote user uid:$remoteUid left the channel", "offline");
          setState(() {
            _common.remoteUid = null;
          });
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
          String coordinates = String.fromCharCodes(data);
          if (coordinates.compareTo('onoffVideo') == 0) {
            setState(() {
              _common.videoOnOff = !_common.videoOnOff;
            });
          } else if (coordinates.compareTo('heart') == 0) {
            // popUp();
          } else if (coordinates.compareTo(uid_check) == 0) {
            if (pass_check) {
              Get.offAll(() => BottomNavigation());

              //Navigator.pop(context);
            }
          }
        },
      ),
    );
  }

  Future<void> fetchToken(int uid, String channelName, int tokenRole) async {
    // Prepare the Url
    String url =
        '$serverUrl/rtc/$channelName/${tokenRole.toString()}/uid/${uid.toString()}?expiry=${_common.tokenExpireTime.toString()}';

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

  Widget _changeCholor() {
    return SpeedDial(
      icon: Icons.color_lens,
      activeIcon: Icons.color_lens_outlined,
      foregroundColor: sendColor,
      backgroundColor: AppColors.grey,
      activeForegroundColor: sendColor,
      activeBackgroundColor: AppColors.grey,
      spacing: 3,
      spaceBetweenChildren: 4,
      buttonSize: Size(73.h, 73.h),
      childrenButtonSize: Size(37.w, 37.h),
      renderOverlay: false,
      elevation: 0.0,
      children: [
        SpeedDialChild(
          child: Container(),
          backgroundColor: AppColors.grey[50],
          onTap: () {
            setState(() {
              sendColor = AppColors.grey[50]!;
            });
            _common.agoraEngine.sendStreamMessage(
                streamId: _common.streamId!,
                data: Uint8List.fromList("grey".codeUnits),
                length: Uint8List.fromList("grey".codeUnits).length);
          },
          // onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
        ),
        SpeedDialChild(
          child: Container(),
          backgroundColor: AppColors.primaryColor,
          onTap: () {
            setState(() {
              sendColor = AppColors.primaryColor;
            });
            _common.agoraEngine.sendStreamMessage(
                streamId: _common.streamId!,
                data: Uint8List.fromList("primary".codeUnits),
                length: Uint8List.fromList("primary".codeUnits).length);
          },
          // onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
        ),
        SpeedDialChild(
          child: Container(),
          backgroundColor: AppColors.secondaryColor,
          onTap: () {
            setState(() {
              sendColor = AppColors.secondaryColor;
            });
            _common.agoraEngine.sendStreamMessage(
                streamId: _common.streamId!,
                data: Uint8List.fromList("secondary".codeUnits),
                length: Uint8List.fromList("secondary".codeUnits).length);
          },
          // onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
        ),
        SpeedDialChild(
          child: Container(),
          backgroundColor: Colors.red,
          onTap: () {
            setState(() {
              sendColor = Colors.red;
            });
            _common.agoraEngine.sendStreamMessage(
                streamId: _common.streamId!,
                data: Uint8List.fromList("red".codeUnits),
                length: Uint8List.fromList("red".codeUnits).length);
          },
          // onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
        ),
      ],
    );
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      //if (heart == true) heartPop(),
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _changeCholor(),
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
    // Get.back();
    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.uid)
        .update({'help': FieldValue.increment(1)});
    Get.offAll(() => BottomNavigation());
    //Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      _common.muted = !_common.muted;
    });
    _common.agoraEngine.muteLocalAudioStream(_common.muted);
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

  Widget circleDrawing(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              setState(() {
                location = details.localPosition;
              });
              _common.value = 0;
              _common.timer =
                  Timer.periodic(const Duration(milliseconds: 2), (t) {
                setState(() {
                  if (_common.value < 100) {
                    _common.value++;
                  } else {
                    _common.subtract = (MediaQuery.of(context).size.height -
                            (MediaQuery.of(context).size.width / 3 * 4)) /
                        2;
                    _common.timer.cancel();
                    nomalizationDx = details.localPosition.dx /
                        MediaQuery.of(context).size.width;
                    nomalizationDy =
                        (details.localPosition.dy - _common.subtract) /
                            (MediaQuery.of(context).size.width / 3 * 4);
                    getdetails = nomalizationDx.toString() +
                        " " +
                        nomalizationDy.toString() +
                        "a";
                    _common.agoraEngine.sendStreamMessage(
                        streamId: _common.streamId!,
                        data: Uint8List.fromList(getdetails.codeUnits),
                        length:
                            Uint8List.fromList(getdetails.codeUnits).length);
                  }
                });
                //print('value $value');
              });
            },
          ),
        ),
        CustomPaint(
          size: Size(Config.screenWidth! * 0.2, Config.screenWidth! * 0.2),
          painter: PieChart(
            percentage: _common.value,
            location: location,
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
            : Center(
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width / 3 * 4,
                        child: _viewRows(),
                      ),
                    ),
                    // if (heart == true) heartPop(),
                    // _panel(),
                    _common.muted ? voiceOff(context) : Container(),
                    circleDrawing(context),
                    _toolbar(),
                  ],
                ),
              ));
  }

  Widget _viewRows() {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.width / 3 * 4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(border: Border.all()),
        child: Center(child: _remoteVideo()),
      ),
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

  // @override
  // Widget build(BuildContext context) {
  //   return Container();
  // }

  /*
  사용하지 않는 것

  //bool heart = false;
  final _random = math.Random();
  late Timer _timer;
  double height = 0.0;
  final int _numConfetti = 10;
  var len;
  bool accepted = false;
  bool stop = false;

  void popUp() async {
    setState(() {
      heart = true;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 125), (Timer t) {
      setState(() {
        height += _random.nextInt(20);
      });
    });

    Timer(
        const Duration(seconds: 4),
        () => {
              _timer.cancel(),
              setState(() {
                heart = false;
              })
            });
  }

  Widget heartPop() {
    final size = MediaQuery.of(context).size;
    final confetti = <Widget>[];
    for (var i = 0; i < _numConfetti; i++) {
      final height = _random.nextInt(size.height.floor());
      final width = 0;
      confetti.add(HeartAnim(
        height % 300.0,
        //width.toDouble(),
        1,
      ));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Align(
        alignment: Alignment.bottomRight,
        child: SizedBox(
          //height: 0,
          width: (MediaQuery.of(context).size.width / 2),
          child: Stack(
            children: confetti,
          ),
        ),
      ),
    );
  }

  /// Info panel to show logs
  Widget _panel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return const Text(
                    "null"); // return type can't be null, a widget was required
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          _infoStrings[index],
                          style: const TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

   */
