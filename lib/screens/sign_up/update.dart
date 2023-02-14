import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livq/controllers/auth_controller.dart';
import 'package:livq/screens/welcome_page.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';
import 'package:livq/widgets/rounded_elevated_button.dart';
import 'package:livq/widgets/rounded_text_formfield.dart';
import 'package:flutter/material.dart';
import '../../config.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../root.dart';

class UpdateWidget extends StatefulWidget {
  const UpdateWidget({Key? key}) : super(key: key);

  @override
  _UpdateWidgetState createState() => _UpdateWidgetState();
}

class _UpdateWidgetState extends State<UpdateWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _authController = Get.find<AuthController>();
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: Config.screenWidth! * 0.9,
          height: Config.screenHeight! * 1.5,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: Config.screenHeight! * 0.15),
                  //Text("Log In",style: TextStyle(fontSize: Config.screenWidth! * 0.08),),
                  Container(
                    height: ScreenUtil().setHeight(115),
                    width: ScreenUtil().setWidth(86),
                    child: SvgPicture.asset(
                      'assets/liveQ_logo.svg',
                    ),
                  ),
                  SizedBox(height: Config.screenHeight! * 0.02),
                  Column(
                    children: [
                      Platform.isIOS
                          ? SizedBox(
                              height: 30.h,
                            )
                          : Container(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '도움',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(18),
                                  color: Color(0xFFffaa00)),
                            ),
                            Text(
                              '과',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(18),
                                  color: Color(0xFF5B21B6)),
                            ),
                            Text(
                              '소통',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(18),
                                  color: Color(0xFFffaa00)),
                            ),
                            Text(
                              '의 제한 없는 공간',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(18),
                                  color: Color(0xFF5B21B6)),
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Platform.isIOS
                                ? SizedBox(
                                    height: 50.h,
                                  )
                                : Container(),
                            Text(
                              '라이큐',
                              style: TextStyle(
                                  fontSize: ScreenUtil().setSp(22),
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5B21B6)),
                            ),
                            Platform.isIOS
                                ? SizedBox(
                                    height: 50.h,
                                  )
                                : Container(),
                          ]),
                      //SizedBox(height: ScreenUtil().setHeight(9)),
                      Text(
                        '세상의 모든 어려움의',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(12),
                            color: Color(0xFF979797)),
                      ),
                      Text(
                        '장벽을 허물어주는 어플',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(12),
                            color: Color(0xFF979797)),
                      ),
                    ],
                  ),
                  SizedBox(height: Config.screenHeight! * 0.04),
                  Text(
                    '다음버전으로 업데이트가 필요합니다.',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(22),
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF5B21B6)),
                  ),
                  Platform.isIOS
                      ? Text(
                          'App store에서 업데이트를 진행해주세요',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(18),
                              color: Color(0xFFffaa00)),
                        )
                      : Text(
                          'Google play store에서 업데이트를 진행해주세요',
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(18),
                              color: Color(0xFFffaa00)),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
