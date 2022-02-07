import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livq/screens/home/agora/utils/settings.dart';
import 'package:livq/screens/home/buttons/animated_radial_menu.dart';
import 'package:livq/screens/navigation_bar.dart';
import 'package:livq/theme/colors.dart';

import '../../../../config.dart';
import 'pie_chart.dart';
import 'heart.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CallPage_helper extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String? channelName;
  const CallPage_helper({Key? key, this.channelName}) : super(key: key);

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage_helper> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool videoOnOff = false;
  late RtcEngine _engine;
  int? streamId;
  late Offset change;
  bool heart = false;
  int helper_one = 0;
  late String uid_check;
  int count = 1;
  bool get_uid = true;
  bool pass_check = true;

  //원 그리기 변수
  late Timer timer;
  bool _isPlaying = false;
  var value = 0;
  Offset? location;
  late String getdetails;
  late double nomalizationDx;
  late double nomalizationDy;
  late double subtract;
  Color sendColor = AppColors.primaryColor;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
//원 그리기 변수
    timer.cancel();
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
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();

    streamId = await _engine.createDataStream(false, false);

    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    //configuration.dimensions = VideoDimensions(1920, 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel(null, widget.channelName!, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.Communication);
    //만약에 1to1으로 만들려면 LiveBroadcasting이거 대신에 Communication으로 넣으면 일대일이 가능해짐
    //await _engine.setClientRole(ClientRole.Broadcaster);
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  User? get userProfile => auth.currentUser;
  User? currentUser;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {
          final info = 'onError: $code';
          _infoStrings.add(info);
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          final info = 'onJoinChannel: $channel, uid: $uid';
          _infoStrings.add(info);
        });
      },
      leaveChannel: (stats) {
        setState(() {
          _infoStrings.add('onLeaveChannel');
          _users.clear();
        });
      },
      userJoined: (uid, elapsed) {
        setState(() {
          final info = 'userJoined: $uid';
          _infoStrings.add(info);
          _users.add(uid);
        });
        if (get_uid) {
          uid_check = uid.toString();
          get_uid = false;
        }
      },
      userOffline: (uid, elapsed) {
        setState(() {
          final info = 'userOffline: $uid';
          _infoStrings.add(info);
          _users.remove(uid);
        });
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        pass_check = false;
        setState(() {
          final info = 'firstRemoteVideo: $uid ${width}x $height';
          _infoStrings.add(info);
        });
      },
      streamMessage: (_, __, coordinates) {
        if (coordinates.compareTo('end') == 0) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(firebaseUser!.uid)
              .update({'help': FieldValue.increment(1)});
          Get.offAll(() => Navigation());
          // Navigator.pop(context);
        } else if (coordinates.compareTo('onoffVideo') == 0) {
          setState(() {
            videoOnOff = !videoOnOff;
          });
        } else if (coordinates.compareTo('heart') == 0) {
          // popUp();
        } else if (coordinates.compareTo(uid_check) == 0) {
          if (pass_check) {
            Get.offAll(() => Navigation());

            //Navigator.pop(context);
          }
        }
      },
      streamMessageError: (_, __, error, ___, ____) {
        final String info = "here is the error $error";
        print(info);
      },
    ));
  }

  // Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    //if (widget.role == ClientRole.Broadcaster) {}
    for (var uid in _users) {
      list.add(RtcRemoteView.SurfaceView(
          uid: uid, renderMode: VideoRenderMode.FILL));
    }
    list.add(RtcLocalView.SurfaceView(renderMode: VideoRenderMode.FILL));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 3 * 4,
        child: view);
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 3 * 4,
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  // Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container();
      case 2:
        const CircularProgressIndicator();
        return Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
          ],
        );
      default:
    }
    return Container();
  }

  /*
// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container();
      case 2:
        const CircularProgressIndicator();
        return Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
          ],
        );
      default:
    }
    return Container();
  }

  */

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      //if (heart == true) heartPop(),
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // RawMaterialButton(
          //     onPressed: _onSwitchCamera,
          //     child: Icon(
          //       videoOnOff ? Icons.videocam_off : Icons.videocam,
          //       color: videoOnOff ? Colors.white : AppColors.primaryColor,
          //       size: 45.h,
          //     ),
          //     shape: const CircleBorder(),
          //     elevation: 4.0,
          //     fillColor: videoOnOff ? AppColors.grey[700] : Colors.white,
          //     padding: const EdgeInsets.all(12.0),
          //   ),

          SpeedDial(
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
                  _engine.sendStreamMessage(streamId!, "grey");
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
                  _engine.sendStreamMessage(streamId!, "primary");
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
                  _engine.sendStreamMessage(streamId!, "secondary");
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
                  _engine.sendStreamMessage(streamId!, "red");
                },
                // onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
              ),
            ],
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
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : AppColors.primaryColor,
              size: 45.h,
            ),
            shape: const CircleBorder(),
            elevation: 4.0,
            fillColor: muted ? AppColors.grey[700] : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
        ],
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    _engine.sendStreamMessage(streamId!, "end");
    // Get.back();
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .update({'help': FieldValue.increment(1)});
    Get.offAll(() => Navigation());
    //Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
      print(muted);
    });
    _engine.muteLocalAudioStream(muted);
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
              value = 0;
              timer = Timer.periodic(const Duration(milliseconds: 2), (t) {
                setState(() {
                  if (value < 100) {
                    value++;
                  } else {
                    subtract = (MediaQuery.of(context).size.height -
                            (MediaQuery.of(context).size.width / 3 * 4)) /
                        2;
                    timer.cancel();
                    nomalizationDx = details.localPosition.dx /
                        MediaQuery.of(context).size.width;
                    nomalizationDy = (details.localPosition.dy - subtract) /
                        (MediaQuery.of(context).size.width / 3 * 4);
                    getdetails = nomalizationDx.toString() +
                        " " +
                        nomalizationDy.toString() +
                        "a";
                    _engine.sendStreamMessage(streamId!, getdetails);
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
            percentage: value,
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
        body: videoOnOff
            ? Center(
                child: Stack(
                  children: <Widget>[
                    _turnoffcamera(),
                    // if (heart == true) heartPop(),
                    // _panel(),
                    muted ? voiceOff(context) : Container(),
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
                    muted ? voiceOff(context) : Container(),
                    circleDrawing(context),
                    _toolbar(),
                  ],
                ),
              ));
  }

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
}
