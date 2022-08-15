import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:livq/screens/my_page/app_setting_page.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/widgets/firebaseAuth.dart';
import 'package:livq/widgets/common_widget.dart';
import 'package:livq/widgets/listTile_widget.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: textWidget("마이 페이지", TextStyle(color: Colors.black)),
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {Get.to(appSettingPage());},
              icon: const Icon(Icons.settings_sharp, color: Colors.black))
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                sizedBoxWidget(0, 50),
                sizedBoxWithChild(120, 120, UserFutureBuilder(data: 'photoURL',textStyle: TextStyle())),
                sizedBoxWidget(0, 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _orangeCicle(),
                    sizedBoxWidget(4, 0),
                    UserFutureBuilder(data: 'name',
                      textStyle: TextStyle(color: AppColors.secondaryColor[800], fontSize: 18.sp, fontWeight: FontWeight.w500,),)
                  ],
                ),
                textWidget( '오늘도 행복하세요!', TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.w500,),),
                sizedBoxWidget(0, 40),
                _pointWidget(),
                sizedBoxWidget(0, 10),
                Column(
                  children: [
                    sizedBoxWidget(0, 5),
                    listTileWidget('친구 추가하기'),
                    dividerWidget(0),
                    listTileWidget('회원정보 수정'),
                    dividerWidget(5),
                    listTileWidget('통화기록'),
                    dividerWidget(0),
                    listTileWidget('받은 감사편지'),
                    dividerWidget(0),
                    listTileWidget('랭킹'),
                    dividerWidget(5),
                    listTileWidget('공지사항'),
                    dividerWidget(0),
                    listTileWidget('1:1 문의'),
                    dividerWidget(0),
                    listTileWidget('사용설명서'),
                    dividerWidget(0),
                    listTileWidget('리뷰 쓰러가기'),
                    dividerWidget(0),
                    listTileWidget('라이큐 공유'),
                    dividerWidget(5),
                    listTileWidget('앱 설정'),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

Widget _orangeCicle() {
  return Container(
    width: 8.w,
    height: 8.h,
    decoration: const BoxDecoration(
      color: AppColors.primaryColor,
      borderRadius: BorderRadius.all(
        Radius.circular(4.0),
      ),
    ),
  );
}

Widget _pointWidget() {
  return  Container(height: 74.h, decoration: const BoxDecoration( borderRadius: BorderRadius.all(Radius.circular(12),),),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 17.h,
                child: SvgPicture.asset(
                  "assets/my_page/heartIcon.svg",
                ),
              ),
              sizedBoxWidget(0, 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(
                    "받은 하트",
                    TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                  sizedBoxWidget(2, 0),
                  Column(
                    children: [
                      UserStreamBuilder(
                          data: 'getHeart',
                          textStyle: TextStyle(
                            fontSize: 9.sp,
                            color: AppColors.primaryColor,
                          )),
                      sizedBoxWidget(0, 5),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: 100.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 19.h,
                child: Image.asset(
                  "assets/my_page/yellow_i.png",
                ),
              ),
              sizedBoxWidget(0, 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(
                    "응답 횟수",
                    TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.grey[700],
                    ),
                  ),
                  sizedBoxWidget(2, 0),
                  Column(
                    children: [
                      UserStreamBuilder(
                        data: 'help',
                        textStyle: TextStyle(
                            fontSize: 9.sp,
                            color: AppColors.primaryColor),
                      ),
                      sizedBoxWidget(0, 5),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: 100.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 18.h,
                child: Image.asset(
                  "assets/my_page/star_icon.png",
                ),
              ),
              sizedBoxWidget(0, 13),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textWidget(
                    "질문 횟수",
                    TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.grey[700],
                    ),
                  ),
                  sizedBoxWidget(2, 0),
                  Column(
                    children: [
                      UserStreamBuilder( data: 'ask', textStyle: TextStyle(
                          fontSize: 9.sp,
                          color: AppColors.primaryColor),
                      ),
                      sizedBoxWidget(0, 5),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}