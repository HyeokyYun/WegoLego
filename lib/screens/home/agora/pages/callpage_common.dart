import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:livq/screens/root.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../config.dart';
import '../../../../firebaseAuth.dart';
import '../../../../push_notification/push_notification.dart';
import '../../../../theme/colors.dart';
import '../../../navigation/bottom_navigation.dart';
import '../widgets/call_common.dart';
import '../utils/settings.dart';
import '../widgets/pie_chart.dart';
import 'thank_you.dart';

const String appId = '3314a275f7114db58caaadebfab9679d';

class CallPage_common extends StatefulWidget {
  final String? channelName;
  final int? uid;
  final String? category;
  final String? friendUid;

  const CallPage_common(
      {Key? key, this.channelName, this.uid, this.category, this.friendUid})
      : super(key: key);

  @override
  State<CallPage_common> createState() => _CallPage_commonState();
}

class _CallPage_commonState extends State<CallPage_common> {
  late String token;
  String serverUrl =
      "https://agora-token-service-production-a63e.up.railway.app"; // The base URL to your token server, for example "https://agora-token-service-production-92ff.up.railway.app"

  // late int? widget.uid; // uid of the local user

  bool _isHost =
      true; // Indicates whether the user has joined as a host or audience

  int tokenExpireTime = 15; // Expire time in Seconds.
  bool isTokenExpiring = false; // Set to true when the token is about to expire

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance
  int? streamId;
  late Color sendColor;

  bool sentNotification = false;

  Call_common _common = Call_common();

  Offset? location;

  late ChannelMediaOptions options;

  @override
  void initState() {
    super.initState();
    // Set up an instance of Agora engine
    sendColor = AppColors.primaryColor;
    setupVideoSDKEngine();
  }

  // Clean up the resources when you leave
  @override
  void dispose() async {
    // await agoraEngine.leaveChannel();
    await agoraEngine.leaveChannel();
    super.dispose();
  }

  Future<void> fetchToken(int uid, String channelName) async {
    // Prepare the Url
    late int tokenRole;
    widget.uid == 2
        ? tokenRole = 1
        : tokenRole =
            0; // use 1 for Host/Broadcaster, 2 for Subscriber/Audience

    String url =
        '$serverUrl/rtc/$channelName/${tokenRole.toString()}/uid/${uid.toString()}?expiry=${tokenExpireTime.toString()}';

    // Send the request
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // If the server returns an OK response, then parse the JSON.
      Map<String, dynamic> json = jsonDecode(response.body);
      String newToken = json['rtcToken'];
      debugPrint('Token Received: $newToken');
      // Use the token to join a channel or renew an expiring token
      // print("newtoken : $newToken");
      setToken(newToken);
    } else {
      // If the server did not return an OK response,
      // then throw an exception.
      throw Exception(
          'Failed to fetch a token. Make sure that your server URL is valid');
    }
  }

  void setToken(String newToken) async {
    token = newToken;

    if (isTokenExpiring) {
      // Renew the token
      agoraEngine.renewToken(token);
      isTokenExpiring = false;
      // showMessage("Token renewed");
    } else {
      // Join a channel.
      // showMessage("Token received, joining a channel...");

      ChannelMediaOptions options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      );

      await agoraEngine
          .joinChannel(
        token: token,
        channelId: widget.channelName!,
        options: options,
        uid: widget.uid!,
      )
          .then((value) async {
        print("joinChannel is done");
      });
    }
  }

  Future<void> setupVideoSDKEngine() async {
    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));

    await agoraEngine.enableVideo();

    DataStreamConfig config =
        await DataStreamConfig(ordered: false, syncWithAudio: false);
    streamId = await agoraEngine.createDataStream(config);
    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        // onConnectionStateChanged: (connection, state, reason) {
        //   Get.snackbar(connection.toString(),
        //       "${state.toString()} : ${reason.toString()}");
        // },
        // onError: ((err, msg) {
        //   Get.snackbar(err.toString(), msg);
        // }),
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) async {
          // Get.snackbar(
          //     "Local user uid:${connection.localUid} joined the channel",
          //     "onJoinChannelSuccess");
          await agoraEngine.switchCamera();
          if (widget.uid == 2) {
            await FirebaseFirestore.instance
                .collection("videoCall")
                .doc(_auth.uid)
                .set({
              "count": 1,
              "timeRegister": DateTime.now().millisecondsSinceEpoch.toString(),
              "uid": _auth.uid,
              "name": _auth.name,
              "subcategory": widget.category,
            });
          }
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          // Get.snackbar(
          //     "Remote user uid:$remoteUid joined the channel", "remote joined");
          setState(() {
            _remoteUid = remoteUid;
            print("_remoteUid $_remoteUid");
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          // Get.snackbar(
          //     "Remote user uid:$remoteUid left the channel", "offline");
          setState(() {
            _remoteUid = null;
          });
          //여기서 나가야함.
          _onCallEnd();
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          // showMessage('Token expiring');
          isTokenExpiring = true;
          setState(() {
            // fetch a new token when the current token is about to expire
            fetchToken(widget.uid!, widget.channelName!);
          });
        },
        onStreamMessage:
            (connection, remoteUid, streamId, data, length, sentTs) {
          String _coordinates = String.fromCharCodes(data);

          // Get.snackbar("got message", _coordinates,
          //     backgroundColor: AppColors.primaryColor);

          late String first;
          late String second;
          late double d1;
          late double d2;

          if (_coordinates.compareTo('onoffVideo') == 0) {
            // Get.snackbar("변경전", _common.videoOnOff.toString());
            setState(() {
              _common.videoOnOff = !_common.videoOnOff;
            });
            Future.delayed(const Duration(milliseconds: 100));
          } else if (_coordinates.compareTo('heart') == 0) {
            // popUp();
          } else if (_coordinates.compareTo('primary') == 0) {
            setState(() {
              sendColor = AppColors.primaryColor;
            });
            Future.delayed(const Duration(milliseconds: 100));
          } else if (_coordinates.compareTo('secondary') == 0) {
            setState(() {
              sendColor = AppColors.secondaryColor;
            });
            Future.delayed(Duration(milliseconds: 100));
          } else if (_coordinates.compareTo('red') == 0) {
            setState(() {
              sendColor = Colors.red;
            });
            Future.delayed(Duration(milliseconds: 100));
          } else {
            _common.subtract = (MediaQuery.of(context).size.height -
                    (MediaQuery.of(context).size.width / 3 * 4)) /
                2;
            first = _coordinates.substring(0, _coordinates.indexOf(' '));
            second = _coordinates.substring(
                _coordinates.indexOf(' '), _coordinates.indexOf('a'));
            d1 = double.parse(first);
            d2 = double.parse(second);

            // Get.snackbar("got coordinate", _common.change.toString(),
            //     backgroundColor: AppColors.primaryColor);

            _common.change = Offset(
                d1 * MediaQuery.of(context).size.width,
                d2 * MediaQuery.of(context).size.width / 3 * 4 +
                    _common.subtract);

            setState(() {
              location = _common.change;
              _common.value = 0;
              _common.timer =
                  Timer.periodic(const Duration(milliseconds: 2), (t) {
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
    join();
  }

  void join() async {
    if (_isHost) {
      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      );
      await agoraEngine.startPreview();
    } else {
      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      );
    }

    await fetchToken(widget.uid!, widget.channelName!);
  }

  // void leave() {
  //   setState(() {
  //     _isJoined = false;
  //     _remoteUid = null;
  //   });
  //   agoraEngine.leaveChannel();
  // }

// Build UI
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
                      child: widget.uid == 2 ? _localPreview() : _remoteVideo(),
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
    );
  }

// Display local video preview
  Widget _localPreview() {
    if (_isJoined) {
      //uid가 0으로 되어야만 자기 자신이 나타난다.
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
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
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelName!),
        ),
      );
    } else {
      String msg = '';
      if (_isJoined) msg = 'Waiting for a remote user to join';
      return Text(
        msg,
        textAlign: TextAlign.center,
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
            Get.snackbar("send message", "change the color",
                backgroundColor: AppColors.secondaryColor);
            agoraEngine.sendStreamMessage(
                streamId: streamId!,
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
            agoraEngine.sendStreamMessage(
                streamId: streamId!,
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
            agoraEngine.sendStreamMessage(
                streamId: streamId!,
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
            agoraEngine.sendStreamMessage(
                streamId: streamId!,
                data: Uint8List.fromList("red".codeUnits),
                length: Uint8List.fromList("red".codeUnits).length);
          },
          // onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
        ),
      ],
    );
  }

  late String getdetails;
  late double nomalizationDx;
  late double nomalizationDy;
  Widget circleDrawing(BuildContext context) {
    return Stack(
      children: [
        // widget.uid == 2
        //     ? Container()
        //     :

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

                    // Get.snackbar("location", getdetails.codeUnits.toString());
                    // Get.snackbar("send coordinate", "coordinate",
                    //     backgroundColor: AppColors.secondaryColor);
                    agoraEngine.sendStreamMessage(
                        streamId: streamId!,
                        data: Uint8List.fromList(getdetails.codeUnits),
                        length:
                            Uint8List.fromList(getdetails.codeUnits).length +
                                1);
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

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      //if (heart == true) heartPop(),
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.uid == 2
              ? RawMaterialButton(
                  onPressed: _onSwitchCamera,
                  child: Icon(
                    _common.videoOnOff ? Icons.videocam_off : Icons.videocam,
                    color: _common.videoOnOff
                        ? Colors.white
                        : AppColors.primaryColor,
                    size: 45.h,
                  ),
                  shape: const CircleBorder(),
                  elevation: 4.0,
                  fillColor:
                      _common.videoOnOff ? AppColors.grey[700] : Colors.white,
                  padding: const EdgeInsets.all(12.0),
                )
              : _changeCholor(),
          // _changeCholor(),
          SizedBox(
            width: 33.w,
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(),
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

  void _onSwitchCamera() {
    // Get.snackbar("onoffVideo", "onoffVideo".codeUnits.toString());

    agoraEngine.sendStreamMessage(
        streamId: streamId!,
        data: Uint8List.fromList("onoffVideo".codeUnits),
        length: Uint8List.fromList("onoffVideo".codeUnits).length);
    // Get.snackbar("videoOnOff", _common.videoOnOff.toString());
    setState(() {
      _common.videoOnOff = !_common.videoOnOff;
    });
  }

  AuthClass _auth = AuthClass();

  void _onCallEnd() async {
    setState(() {
      _common.isJoined = false;
      _common.remoteUid = null;
    });
    //taker / helper
    if (widget.uid == 2)
      FirebaseFirestore.instance
          .collection('videoCall')
          .doc(_auth.uid)
          .delete();

    // await agoraEngine.leaveChannel().then((value) {
    //   Get.snackbar("leaveChannel", "leaveChannel clear");
    // });

    widget.uid == 2
        ? await Get.offAll(() => ThankYouPage())
        : await Get.offAll(() => BottomNavigation());
  }

  void _onToggleMute() {
    setState(() {
      _common.muted = !_common.muted;
    });
    agoraEngine.muteLocalAudioStream(_common.muted);
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
              "음성으로 도움을 주고 받으세요!",
              style: TextStyle(
                color: Color(0xff979797),
                fontSize: 14,
              ),
            ),
            Text(
              "Getting a help or helping with the voice",
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
}
