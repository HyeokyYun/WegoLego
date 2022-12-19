import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:livq/screens/navigation/bottom_navigation.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';
import 'package:livq/widgets/common_widget.dart';


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
                  sizedBoxWidget(20, 0),
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [_circularTimerWidget(context)],
                  ),
                  sizedBoxWidget(173,0),
                  Column(
                    children: [
                      Icon(Icons.directions_bus,size: 32.sp, color:Color(0xffADB5BD)),
                      textWidget('버스', TextStyle(fontSize:12.sp, color: Color(0xFF868E96)),
                      ),
                    ],
                  )
                ],
              ),
              sizedBoxWidget(0, 140),
              SvgPicture.asset("assets/liveQ_logo.svg", width: 91.w, height: 63.h,),
              sizedBoxWidget(0, 30),
              Icon(Icons.circle, size: 8, color:Color(0xffFABF8B)),
              sizedBoxWidget(0, 16),
              Icon(Icons.circle, size: 8, color:Color(0xffF79F51)),
              sizedBoxWidget(0, 16),
              Icon(Icons.circle, size: 8, color:Color(0xffF57F17)),
              Column(
                children: [
                  Column(children: [
                    sizedBoxWidget(0, 18),
                    textWidget('답변자 매칭 중이에요', TextStyle(fontSize: 18.sp, color: Color(0xFF212529)),),
                    sizedBoxWidget(0, 16),
                    textWidget('매칭이 완료되면 실시간 화면', TextStyle(fontSize: 14.sp, color: Color(0xFF212529)),),
                    sizedBoxWidget(1, 0),
                    textWidget('공유를 통해 질문을 할 수 있어요', TextStyle(fontSize:14.sp,color: Color(0xFF212529)),
                    ),
                  ]),
                  sizedBoxWidget(0, 144),
                  SizedBox(height:49.h, width: 287.w,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: textWidget('매칭 취소하기',TextStyle(fontSize: 14.sp, color: Colors.black),),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xffE9ECEF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(33),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
      ),
    )
    );
  }


  Widget _circularTimerWidget(BuildContext context){
    return CircularCountDownTimer(
      duration: _duration,
      initialDuration: 0,
      controller: _controller,
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height / 2,
      ringColor: AppColors.primaryColor[200]!,
      ringGradient: null,
      fillColor: AppColors.primaryColor[600]!,
      fillGradient: null,
      backgroundColor: AppColors.primaryColor,
      backgroundGradient: null,
      strokeWidth: 20.0,
      strokeCap: StrokeCap.round,
      textStyle: AppTextStyle.koBody2,
      textFormat: "남은시간\n${CountdownTextFormat.S}",
      isReverse: true,
      isReverseAnimation: true,
      isTimerTextShown: true,
      autoStart: false,
      onComplete: () {
        Get.snackbar('매칭이 되지 않았습니다!', "다시 연결해주세요!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.primaryColor,
            colorText: Colors.white);
        Get.offAll(BottomNavigation());
      },
    );
  }
}
