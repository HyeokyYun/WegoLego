import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:livq/screens/navigation_bar.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';

// ignore: camel_case_types
class WaitingPage extends StatelessWidget {
  CountDownController _controller = CountDownController();
  int _duration = 60;

  @override
  Widget build(BuildContext context) {
    _controller.start();
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
                      Container(
                        child: Container(
                          child: CircularCountDownTimer(
                            // Countdown duration in Seconds.
                            duration: _duration,

                            // Countdown initial elapsed Duration in Seconds.
                            initialDuration: 0,

                            // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
                            controller: _controller,

                            // Width of the Countdown Widget.
                            width: MediaQuery.of(context).size.width / 2,

                            // Height of the Countdown Widget.
                            height: MediaQuery.of(context).size.height / 2,

                            // Ring Color for Countdown Widget.
                            ringColor: AppColors.primaryColor[200]!,

                            // Ring Gradient for Countdown Widget.
                            ringGradient: null,

                            // Filling Color for Countdown Widget.
                            fillColor: AppColors.primaryColor[600]!,

                            // Filling Gradient for Countdown Widget.
                            fillGradient: null,

                            // Background Color for Countdown Widget.
                            backgroundColor: AppColors.primaryColor,

                            // Background Gradient for Countdown Widget.
                            backgroundGradient: null,

                            // Border Thickness of the Countdown Ring.
                            strokeWidth: 20.0,

                            // Begin and end contours with a flat edge and no extension.
                            strokeCap: StrokeCap.round,

                            // Text Style for Countdown Text.
                            textStyle: AppTextStyle.koBody2,

                            // Format for the Countdown Text.
                            textFormat: "남은시간\n${CountdownTextFormat.S}",

                            // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
                            isReverse: true,

                            // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
                            isReverseAnimation: true,

                            // Handles visibility of the Countdown Text.
                            isTimerTextShown: true,

                            // Handles the timer start.
                            autoStart: false,

                            // This Callback will execute when the Countdown Starts.
                            // onStart: () {
                            //   // Here, do whatever you want
                            //   print('Countdown Started');
                            // },

                            // This Callback will execute when the Countdown Ends.
                            onComplete: () {
                              // Here, do whatever you want
                              // print('Countdown Ended');
                              Get.snackbar('매칭이 되지 않았습니다!', "다시 연결해주세요!",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppColors.primaryColor,
                                  colorText: Colors.white);
                              Get.offAll(Navigation());
                            },
                          ),
                        ),
                      ),
                      // Text(
                      //   '남은 매칭시간',
                      //   style: TextStyle(
                      //       fontSize: ScreenUtil().setSp(14),
                      //       color: Color(0xFFF9A825)),
                      // ),
                      // Text(
                      //   '1:35',
                      //   style: TextStyle(
                      //       fontSize: ScreenUtil().setSp(14),
                      //       color: Color(0xFFF9A825)),
                      // ),
                    ],
                  ),
                  SizedBox(width: ScreenUtil().setWidth(173)),
                  Column(
                    children: [
                      Icon(Icons.directions_bus,
                          size: 32, color: Color(0xffADB5BD)),
                      Text(
                        '버스',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(12),
                            color: Color(0xFF868E96)),
                      ),
                    ],
                  )
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
                  size: ScreenUtil().setHeight(8), color: Color(0xffFABF8B)),
              SizedBox(height: ScreenUtil().setHeight(16)),
              Icon(Icons.circle,
                  size: ScreenUtil().setHeight(8), color: Color(0xffF79F51)),
              SizedBox(height: ScreenUtil().setHeight(16)),
              Icon(Icons.circle,
                  size: ScreenUtil().setHeight(8), color: Color(0xffF57F17)),
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
                        // Get.to(emailLoginPage());
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => emailLoginPage()),
                        // );
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
}
