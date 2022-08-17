import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livq/controllers/auth_controller.dart';
import 'package:livq/screens/reset_password/reset_password.dart';
import 'package:livq/screens/sign_up/sign_up.dart';
import 'package:livq/widgets/rounded_elevated_button.dart';
import 'package:livq/widgets/rounded_text_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import '../../config.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:livq/theme/text_style.dart';
import '../../widgets/common_widget.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _authController = Get.find<AuthController>();
    return Center(
      child: SizedBox(
        width: Config.screenWidth! * 0.9,
        height: Config.screenHeight! * 1.5,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                sizedBoxWidget(0, 80),
                _logoContentWidget(115,86),
                sizedBoxWidget(0, 20),
                Column(children: [
                  Platform.isIOS
                      ? sizedBoxWidget(0, 30)
                      : Container(),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    textWidget('도움', AppTextStyle.appLogoOrangeStyle),
                    textWidget('과', AppTextStyle.appLogoPurpleStyle),
                    textWidget('소통', AppTextStyle.appLogoOrangeStyle),
                    textWidget( '의 제한 없는 공간',  AppTextStyle.appLogoPurpleStyle),
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Platform.isIOS
                        ? sizedBoxWidget(0, 50)
                        : Container(),
                    textWidget( '라이트큐',  TextStyle(
                        fontSize: ScreenUtil().setSp(22),
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5B21B6))),
                    Platform.isIOS
                        ? sizedBoxWidget(0, 50)
                        : Container(),
                  ]),
                  sizedBoxWidget(0, 10),
                  textWidget( '세상의 모든 어려움의', AppTextStyle.appContentGreyStyle ),
                  textWidget( '장벽을 허물어주는 어플', AppTextStyle.appContentGreyStyle ),
                ]),
                sizedBoxWidget(0, 40),
                Platform.isIOS
                    ? Container()
                    : Column(
                        children: [
                          buildTextFormFields(),
                          Padding(
                            padding: EdgeInsets.all(0),
                            // EdgeInsets.symmetric(vertical: Config.screenHeight! * 0.005),
                            child: Align(
                              alignment: Alignment(0.8, 0.0),
                              child: _textFindPasswordButton('비밀번호 찾기')
                            ),
                          ),
                          sizedBoxWidget(0, 15),

                          RoundedElevatedButton(
                            title: '로그인 ',
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                String email = _emailController.text.trim();
                                String password = _passwordController.text;
                                _authController.signIn(email, password);
                              }
                            },
                          ),
                        ],
                      ),
                Platform.isIOS
                    ? SignInButton(
                        buttonType: ButtonType.google,
                        onPressed: () => _authController.signInWithGoogle(),
                      )
                    : SignInButton.mini(
                        buttonType: ButtonType.google,
                        onPressed: () => _authController.signInWithGoogle(),
                      ),
                Platform.isIOS
                    ?  sizedBoxWidget(0, 10)
                    : Container(),
                Platform.isIOS
                    ? SignInButton(
                        buttonType: ButtonType.appleDark,
                        onPressed: () => _authController.signInWithApple(),
                      )
                    : Container(),
                Platform.isIOS
                    ?  sizedBoxWidget(0, 30)
                    : Container(),

                Platform.isIOS
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textWidget( '라이트큐 회원이 아니신가요? ',TextStyle()),
                          TextButton(
                             child:  textWidget( '회원가입', TextStyle(
                               color: Color(0xffFFAA00),
                             ) ),
                            onPressed: () => Get.to(() => const SignUp()),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFormFields() {
    return Column(
      children: [
        RoundedTextFormField(
          controller: _emailController,
          hintText: '이메일',
        ),

        SizedBox(height: Config.screenHeight! * 0.01),
        RoundedTextFormField(
          controller: _passwordController,
          hintText: '비밀번호 ',
          obsecureText: true,
        ),
      ],
    );
  }
}


Widget _logoContentWidget(int height, int width){
  return Container(
    height: ScreenUtil().setHeight(height),
    width: ScreenUtil().setWidth(width),
    child: SvgPicture.asset(
      'assets/liveQ_logo.svg',
    ),
  );
}
Widget _textFindPasswordButton(String text){
  return TextButton(
    child:  textWidget( text, TextStyle(
      fontSize: ScreenUtil().setSp(14),
      color: Colors.grey,
      decoration: TextDecoration.underline,
    ), ),
    onPressed: () =>
        Get.to(() => const ResetPassword()),
    style: ButtonStyle(
      overlayColor: MaterialStateColor.resolveWith(
              (states) => Colors.transparent),
    ),
  );
}