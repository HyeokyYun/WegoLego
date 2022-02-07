import 'package:livq/controllers/auth_controller.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/widgets/rounded_elevated_button.dart';
import 'package:livq/widgets/rounded_text_formfield.dart';
import 'package:flutter/material.dart';
import '../../config.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../root.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _checkBoxValue = true;
  bool _checkBoxValue1 = false;
  bool _checkBoxValue2 = false;
  bool _checkBoxValue3 = false;

  bool isEnabled = false;
  bool isButtonActive = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _authController = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Sign Up',
        //   textAlign: TextAlign.center,
        //   style: TextStyle(color: Colors.black),
        // ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Config.screenWidth! * 0.04),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Config.screenHeight! * 0.07),
                  Text(
                    "회원가입 ",
                    style: TextStyle(fontSize: Config.screenWidth! * 0.06),
                  ),
                  SizedBox(height: Config.screenHeight! * 0.05),
                  buildTextFormFields(),
                  SizedBox(height: Config.screenHeight! * 0.05),
                  // RoundedElevatedButton(
                  //   onPressed: () {
                  //     if (_formKey.currentState!.validate()) {
                  //       String name = _nameController.text.trim();
                  //       String email = _emailController.text.trim();
                  //       String password = _passwordController.text;
                  //       _authController.signUp(name, email, password);
                  //     }
                  //   },
                  //   title: '회원가입 ',
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: Config.screenWidth! * 0.38,
                  //     vertical: Config.screenHeight! * 0.02,
                  //   ),
                  // ),
                  SizedBox(
                    height: ScreenUtil().setHeight(49),
                    width: ScreenUtil().setWidth(287),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return AlertDialog(
                                      // context: context,
                                      actions: [
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  '이용약관 ',
                                                  style: TextStyle(
                                                    fontSize:
                                                        ScreenUtil().setSp(18),
                                                  ),
                                                )
                                                // IconButton(onPressed: (){},
                                                //     icon: Icon(Icons.done))
                                              ],
                                            ),
                                            SizedBox(
                                                height:
                                                    ScreenUtil().setHeight(50)),
                                            Row(children: [
                                              Checkbox(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                checkColor: Colors.white,
                                                activeColor: Color(0xffFFAA00),
                                                value: _checkBoxValue,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    _checkBoxValue = value!;

                                                    if (_checkBoxValue ==
                                                        true) {
                                                      _checkBoxValue1 = true;
                                                      _checkBoxValue2 = true;
                                                      _checkBoxValue3 = true;

                                                      isEnabled = true;
                                                    }
                                                    ;
                                                    if (_checkBoxValue ==
                                                        false) {
                                                      _checkBoxValue1 = false;
                                                      _checkBoxValue2 = false;
                                                      _checkBoxValue3 = false;
                                                      isEnabled = false;
                                                    }
                                                    ;
                                                  });
                                                },
                                              ),
                                              Text('약관 전체동의 '),
                                            ]),
                                            SizedBox(
                                                height:
                                                    ScreenUtil().setHeight(4)),
                                            Container(
                                              height: 1,
                                              width: double.maxFinite,
                                              color: Colors.grey,
                                            ),
                                            SizedBox(
                                                height:
                                                    ScreenUtil().setHeight(4)),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  // SizedBox(width: ScreenUtil().setWidth(15),),
                                                  Row(children: [
                                                    Checkbox(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      checkColor: Colors.white,
                                                      activeColor:
                                                          Color(0xffFFAA00),
                                                      value: _checkBoxValue1,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          _checkBoxValue1 =
                                                              value!;

                                                          if (_checkBoxValue1 ==
                                                              false) {
                                                            _checkBoxValue =
                                                                false;
                                                            isEnabled = false;
                                                          }
                                                          ;

                                                          if (_checkBoxValue1 == true &&
                                                              _checkBoxValue2 ==
                                                                  true &&
                                                              _checkBoxValue3 ==
                                                                  true) {
                                                            _checkBoxValue =
                                                                true;
                                                            isEnabled = true;
                                                          }
                                                          ;
                                                        });
                                                      },
                                                    ),
                                                    Text('개인정보 수집 동의 (필수)'),
                                                  ]),
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(Icons
                                                          .arrow_forward_ios_rounded))
                                                ]),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(children: [
                                                    Checkbox(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      checkColor: Colors.white,
                                                      activeColor:
                                                          Color(0xffFFAA00),
                                                      value: _checkBoxValue2,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          _checkBoxValue2 =
                                                              value!;

                                                          if (_checkBoxValue2 ==
                                                              false) {
                                                            _checkBoxValue =
                                                                false;
                                                            isEnabled = false;
                                                          }
                                                          ;
                                                          if (_checkBoxValue1 == true &&
                                                              _checkBoxValue2 ==
                                                                  true &&
                                                              _checkBoxValue3 ==
                                                                  true) {
                                                            _checkBoxValue =
                                                                true;
                                                            isEnabled = true;
                                                          }
                                                          ;
                                                        });
                                                      },
                                                    ),
                                                    Text('서비스 이용약관 동의 (필수)'),
                                                  ]),
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(Icons
                                                          .arrow_forward_ios_rounded))
                                                ]),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(children: [
                                                    Checkbox(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      checkColor: Colors.white,
                                                      activeColor:
                                                          Color(0xffFFAA00),
                                                      value: _checkBoxValue3,
                                                      onChanged: (bool? value) {
                                                        setState(() {
                                                          _checkBoxValue3 =
                                                              value!;

                                                          if (_checkBoxValue3 ==
                                                              false) {
                                                            _checkBoxValue =
                                                                false;
                                                            isEnabled = false;
                                                          }
                                                          ;
                                                          if (_checkBoxValue1 == true &&
                                                              _checkBoxValue2 ==
                                                                  true &&
                                                              _checkBoxValue3 ==
                                                                  true) {
                                                            _checkBoxValue =
                                                                true;
                                                            isEnabled = true;
                                                          }
                                                          ;
                                                        });
                                                      },
                                                    ),
                                                    Text('개인정보 수집 이용 (필수)'),
                                                  ]),
                                                  IconButton(
                                                      onPressed: () {},
                                                      icon: Icon(Icons
                                                          .arrow_forward_ios_rounded))
                                                ]),
                                            SizedBox(
                                              width: ScreenUtil().setHeight(60),
                                            ),
                                            Container(
                                                height:
                                                    ScreenUtil().setHeight(55),
                                                width:
                                                    ScreenUtil().setHeight(400),
                                                child: ElevatedButton(
                                                    onPressed: isEnabled
                                                        ? () {
                                                            String name =
                                                                _nameController
                                                                    .text
                                                                    .trim();
                                                            String email =
                                                                _emailController
                                                                    .text
                                                                    .trim();
                                                            String password =
                                                                _passwordController
                                                                    .text;
                                                            _authController
                                                                .signUp(
                                                                    name,
                                                                    email,
                                                                    password);
                                                          }
                                                        : null,
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: const Color(
                                                          0xffFFAA00),
                                                    ),
                                                    child: Text('회원가입 완료')))
                                          ],
                                        )
                                      ]);
                                });
                              });
                        }
                      },
                      child: Text(
                        "회원가입 ",
                        style: TextStyle(
                            //color: Colors.white,
                            fontSize: Config.screenWidth! * 0.04),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.primaryColor[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('이미 계정이 있으신가요? '),
                      TextButton(
                        child: Text(
                          '로그인 ',
                          style: TextStyle(color: AppColors.primaryColor[800]),
                        ),
                        onPressed: () => Get.offAll(() => Root()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFormFields() {
    return Column(
      children: [
        SizedBox(height: Config.screenHeight! * 0.02),
        RoundedTextFormField(
          controller: _nameController,
          hintText: '닉네임 ',
          validator: (value) {
            if (value.toString().length <= 2) {
              return '2자리 이상 입력해주세요. ';
            }
            return null;
          },
        ),
        SizedBox(height: Config.screenHeight! * 0.02),
        RoundedTextFormField(
          controller: _emailController,
          hintText: '이메일 ',
          validator: (value) {
            bool _isEmailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value!);
            if (!_isEmailValid) {
              return '유효하지 않은 이메일 양식입니다. ';
            }
            return null;
          },
        ),
        SizedBox(height: Config.screenHeight! * 0.02),
        RoundedTextFormField(
          controller: _passwordController,
          obsecureText: true,
          hintText: '비밀번호 ',
          validator: (value) {
            if (value.toString().length < 6) {
              return '비밀번호는 6자리 이상으로 설정해주세요. ';
            }
            return null;
          },
        ),
        SizedBox(height: Config.screenHeight! * 0.02),
        RoundedTextFormField(
          obsecureText: true,
          hintText: '비밀번호 확인 ',
          validator: (value) {
            if (value.trim() != _passwordController.text.trim()) {
              return '비밀번호가 일치하지 않습니다. ';
            }

            return null;
          },
        ),
      ],
    );
  }
}
