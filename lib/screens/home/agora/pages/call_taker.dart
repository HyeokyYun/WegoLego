import 'dart:async';
import 'dart:ui';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livq/screens/home/agora/pages/thank_you.dart';
import 'package:livq/screens/home/agora/utils/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:livq/screens/home/agora/widgets/call_common.dart';
import 'package:livq/screens/home/buttons/animated_radial_menu.dart';
import 'package:livq/screens/navigation/bottom_navigation.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/widgets/firebaseAuth.dart';
import '../../../../config.dart';
import '../widgets/pie_chart.dart';
import '../widgets/heart.dart';
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

  Color sendColor = AppColors.primaryColor;

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

        if (_coordinates.compareTo('end') == 0) {
          Get.offAll(() => ThankYouPage());
        } else if (_coordinates.compareTo('grey') == 0) {
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
    _common.engine.sendStreamMessage(_common.streamId!, "end");
    Get.offAll(() => ThankYouPage());
  }

  void _onToggleMute() {
    setState(() {
      _common.muted = !_common.muted;
    });
    _common.engine.muteLocalAudioStream(_common.muted);
  }

  void _onSwitchCamera() {
    _common.engine.sendStreamMessage(_common.streamId!, "onoffVideo");
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
                  // Column(
                  //   children: [
                  //     Icon(Icons.directions_bus,
                  //         size: 32, color: Color(0xffADB5BD)),
                  //     Text(
                  //       '버스',
                  //       style: TextStyle(
                  //           fontSize: ScreenUtil().setSp(12),
                  //           color: Color(0xFF868E96)),
                  //     ),
                  //   ],
                  // )
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
                        primary: const Color(0xffE9ECEF),
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
          : _helperIn
              ? Center(
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
                )
              : waitingHelper(context),
    );
  }

  //안쓰이는 것들

  /// Info panel to show logs
  // Widget _panel() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 48),
  //     alignment: Alignment.bottomCenter,
  //     child: FractionallySizedBox(
  //       heightFactor: 0.5,
  //       child: Container(
  //         padding: const EdgeInsets.symmetric(vertical: 48),
  //         child: ListView.builder(
  //           reverse: true,
  //           itemCount: _infoStrings.length,
  //           itemBuilder: (BuildContext context, int index) {
  //             if (_infoStrings.isEmpty) {
  //               return const Text(
  //                   "null"); // return type can't be null, a widget was required
  //             }
  //             return Padding(
  //               padding: const EdgeInsets.symmetric(
  //                 vertical: 3,
  //                 horizontal: 10,
  //               ),
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Flexible(
  //                     child: Container(
  //                       padding: const EdgeInsets.symmetric(
  //                         vertical: 2,
  //                         horizontal: 5,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color: Colors.yellowAccent,
  //                         borderRadius: BorderRadius.circular(5),
  //                       ),
  //                       child: Text(
  //                         _infoStrings[index],
  //                         style: const TextStyle(color: Colors.blueGrey),
  //                       ),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget _connecting() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       image: DecorationImage(
  //         image: const NetworkImage(
  //             "https://i.ibb.co/nsVhXLq/black-background.jpg"),
  //         fit: BoxFit.cover,
  //         colorFilter: ColorFilter.mode(
  //             Colors.black.withOpacity(0.5), BlendMode.dstATop),
  //       ),
  //     ),
  //     child: const Center(
  //       child: CircularProgressIndicator(),
  //     ),
  //   );
  // }

  //Love animation
  // final _random = math.Random();
  // late Timer _timer;
  // double height = 0.0;
  // final int _numConfetti = 10;
  // var len;
  // bool accepted = false;
  // bool stop = false;
  // //bool heart = false;

  // void popUp() async {
  //   setState(() {
  //     heart = true;
  //   });
  //   Timer(
  //       const Duration(seconds: 4),
  //       () => {
  //             _timer.cancel(),
  //             setState(() {
  //               heart = false;
  //             })
  //           });
  //   _timer = Timer.periodic(const Duration(milliseconds: 125), (Timer t) {
  //     setState(() {
  //       height += _random.nextInt(20);
  //     });
  //   });
  // }

  // Widget heartPop() {
  //   final size = MediaQuery.of(context).size;
  //   final confetti = <Widget>[];
  //   for (var i = 0; i < _numConfetti; i++) {
  //     final height = _random.nextInt(size.height.floor());
  //     //final width = 0;
  //     confetti.add(HeartAnim(
  //       height % 300.0,
  //       //width.toDouble(),
  //       1,
  //     ));
  //   }

  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 20),
  //     child: Align(
  //       alignment: Alignment.bottomCenter,
  //       child: SizedBox(
  //         //height: 400,
  //         width: (MediaQuery.of(context).size.width) / 2,
  //         child: Stack(
  //           children: confetti,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
