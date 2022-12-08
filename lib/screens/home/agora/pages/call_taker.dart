import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livq/screens/home/agora/utils/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:livq/screens/home/agora/widgets/call_common.dart';
import '../../../../config.dart';
import '../../../../firebaseAuth.dart';
import '../../home.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

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

  Color sendColor = Color(0xff0101ff);

  @override
  void dispose() {
    // clear users
    _common.users.clear();
    // destroy sdk
    _common.engine.leaveChannel();
    _common.engine.destroy();
    _common.timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // initialize agora sdk
    initialize();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _common.infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _common.infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();

    _common.streamId = await _common.engine.createDataStream(false, false);

    _addAgoraEventHandlers();
    await _common.engine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    //configuration.dimensions = VideoDimensions(1920, 1080);
    await _common.engine.setVideoEncoderConfiguration(configuration);
    await _common.engine.joinChannel(null, widget.channelName!, null, 0);
    _common.engine.switchCamera();
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _common.engine = await RtcEngine.create(APP_ID);
    await _common.engine.enableVideo();
    await _common.engine.setChannelProfile(ChannelProfile.Communication);
    //만약에 1to1으로 만들려면 LiveBroadcasting이거 대신에 Communication으로 넣으면 일대일이 가능해짐
    //await _engine.setClientRole(ClientRole.Broadcaster);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _common.engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {
          final info = 'onError: $code';
          _common.infoStrings.add(info);
          print("error occur plz check it ${_common.infoStrings}");
          print("error occur plz check it ${_common.infoStrings}");
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          final info = 'onJoinChannel: $channel, uid: $uid';
          _common.infoStrings.add(info);
        });
        // is_user = uid.toString();
        //여기 들어가 있음
        _controller.start();
        // getTime = int.parse(_controller.getTime());
      },
      leaveChannel: (stats) {
        setState(() {
          _common.infoStrings.add('onLeaveChannel');
          _common.users.clear();
        });
      },
      userJoined: (uid, elapsed) {
        _controller.pause();
        setState(() {
          final info = 'userJoined: $uid';
          _common.infoStrings.add(info);
          _common.users.add(uid);

          _helperIn = true;
        });
      },
      userOffline: (uid, elapsed) {
        setState(() {
          final info = 'userOffline: $uid';
          _common.infoStrings.add(info);
          _common.users.remove(uid);
        });
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        setState(() {
          final info = 'firstRemoteVideo: $uid ${width}x $height';
          _common.infoStrings.add(info);
        });
      },
      streamMessage: (_, __, _coordinates) {
        //final String coordinate = "$message";
        late String first;
        late String second;
        late double d1;
        late double d2;

        if (String.fromCharCodes(_coordinates).compareTo('end') == 0) {
          Get.offAll(() => Home());
        }
      },
      streamMessageError: (_, __, error, ___, ____) {
        final String info = "here is the error $error";
        print(info);
      },
    ));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    //if (widget.role == ClientRole.Broadcaster) {}
    list.add(RtcLocalView.SurfaceView(
      renderMode: VideoRenderMode.FILL,
    ));
    for (var uid in _common.users) {
      list.add(RtcRemoteView.SurfaceView(
        channelId: "test",
        uid: uid,
        renderMode: VideoRenderMode.FILL,
      ));
    }
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: view);
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        //_engine.switchCamera();

        return Stack(
          children: [
            _videoView(views[0]),
            // _connecting(),
          ],
        );
      case 2:
        setState(() {
          _helperIn = true;
        });
        // _controller.clean()
        const CircularProgressIndicator();
        return Stack(
          children: <Widget>[
            _videoView(views[0]),
          ],
        );
      default:
    }
    return Container();
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
              color: _common.videoOnOff ? Colors.white : Color(0xff0101ff),
              size: 45.h,
            ),
            shape: const CircleBorder(),
            elevation: 4.0,
            fillColor: _common.videoOnOff ? Colors.grey : Colors.white,
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
              color: _common.muted ? Colors.white : Color(0xff0101ff),
              size: 45.h,
            ),
            shape: const CircleBorder(),
            elevation: 4.0,
            fillColor: _common.muted ? Colors.grey : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
        ],
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    _common.engine.sendStreamMessage(
        _common.streamId!, Uint8List.fromList("end".codeUnits));
    Get.offAll(() => Home());
  }

  void _onToggleMute() {
    setState(() {
      _common.muted = !_common.muted;
    });
    _common.engine.muteLocalAudioStream(_common.muted);
  }

  void _onSwitchCamera() {
    _common.engine.sendStreamMessage(
        _common.streamId!, Uint8List.fromList("onoffVideo".codeUnits));
    setState(() {
      _common.videoOnOff = !_common.videoOnOff;
    });
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
                    _common.muted ? voiceOff(context) : Container(),
                    _toolbar(),
                  ],
                ),
              ));
  }
}
