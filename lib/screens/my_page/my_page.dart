import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:livq/screens/my_page/sub_pages/friends_add.dart';
import 'package:livq/screens/my_page/sub_pages/guide_page.dart';
import 'package:livq/screens/my_page/app_setting_page.dart';
import 'package:livq/screens/my_page/my_setting_page.dart';
import 'package:livq/screens/my_page/sub_pages/1:1_question.dart';
import 'package:livq/screens/my_page/sub_pages/call_history.dart';
import 'package:livq/screens/my_page/sub_pages/individual_information.dart';
import 'package:livq/screens/my_page/sub_pages/instruction_manual.dart';
import 'package:livq/screens/my_page/sub_pages/ranking.dart';
import 'package:livq/screens/my_page/sub_pages/review.dart';
import 'package:livq/screens/my_page/sub_pages/statechange.dart';
import 'package:livq/screens/my_page/sub_pages/terms_and_conditions.dart';
import 'package:livq/screens/my_page/sub_pages/thanks_letters.dart';
import 'package:livq/screens/root.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';
import 'dart:async';

import 'package:livq/widgets/firebaseAuth.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  AuthClass _auth = AuthClass();

  final TextEditingController _feedbackController = TextEditingController();
  final RatingService _ratingService = RatingService();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> _userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.uid)
        .snapshots();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "마이 페이지",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Get.to(appSettingPage());
              },
              icon: const Icon(
                Icons.settings_sharp,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            //  padding: EdgeInsets.fromLTRB(28, 0, 28, 0),
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SizedBox(
                //   height: 50.h,
                // ),
                // SizedBox(
                //   height: 120.h,
                //   width: 120.w,
                //   child: StreamBuilder<DocumentSnapshot>(
                //     stream: _userStream,
                //     builder:
                //         (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                //       final getdata = snapshot.data;
                //       if (snapshot.hasData) {
                //         print("my_page for test ${getdata?["photoURL"]}");
                //         // return ClipRRect(
                //         //   borderRadius: BorderRadius.circular(57),
                //         //   child: Image.network(
                //         //     getdata?["photoURL"],
                //         //     height: 114.h,
                //         //     width: 114.w,
                //         //     fit: BoxFit.fill,
                //         //   ),
                //         // );
                //         return Container();
                //       } else {
                //         return Container();
                //       }
                //     },
                //   ),
                // ),
                SizedBox(
                  height: 13.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4.h,
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      stream: _userStream,
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        final getdata = snapshot.data;
                        if (snapshot.hasData) {
                          return Text(
                            '${getdata?["name"]}',
                            style: TextStyle(
                              color: AppColors.secondaryColor[800],
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
                  ],
                ),
                Text(
                  '오늘도 행복하세요!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                Container(
                  height: 74.h,
                  decoration: const BoxDecoration(
                    // color: AppColors.grey[50],
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
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
                            SizedBox(
                              height: 13.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "받은 하트",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Column(
                                  children: [
                                    StreamBuilder<DocumentSnapshot>(
                                      stream: _userStream,
                                      builder: (context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshot) {
                                        final getdata = snapshot.data;
                                        if (snapshot.hasData) {
                                          return Text('${getdata?["getHeart"]}',
                                              style: TextStyle(
                                                fontSize: 9.sp,
                                                color: AppColors.primaryColor,
                                              ));
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
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
                            SizedBox(
                              height: 13.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "응답 횟수",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.grey[700],
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Column(
                                  children: [
                                    StreamBuilder<DocumentSnapshot>(
                                      stream: _userStream,
                                      builder: (context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshot) {
                                        final getdata = snapshot.data;
                                        if (snapshot.hasData) {
                                          return Text(
                                            '${getdata?["help"]}',
                                            style: TextStyle(
                                                fontSize: 9.sp,
                                                color: AppColors.primaryColor),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
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
                            SizedBox(
                              height: 13.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "질문 횟수",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.grey[700],
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Column(
                                  children: [
                                    StreamBuilder<DocumentSnapshot>(
                                      stream: _userStream,
                                      builder: (context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshot) {
                                        final getdata = snapshot.data;
                                        if (snapshot.hasData) {
                                          return Text(
                                            '${getdata?["ask"]}',
                                            style: TextStyle(
                                                fontSize: 9.sp,
                                                color: AppColors.primaryColor),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 5.h,
                    ),
                    ListTile(
                      title: Text(
                        '친구 추가하기 ',
                        style: AppTextStyle.koBody2.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18.sp,
                        color: AppColors.grey[500],
                      ),
                      onTap: () {
                        Get.to(FriendAddPage());
                      },
                    ),
                    Divider(
                      color: AppColors.grey[400],
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      stream: _userStream,
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        final getdata = snapshot.data;
                        if (snapshot.hasData) {
                          return ListTile(
                            title: Text(
                              '회원정보 수정',
                              style: AppTextStyle.koBody2.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 18.sp,
                              color: AppColors.grey[500],
                            ),
                            onTap: () {
                              Get.to(mySettingPage(
                                getName: getdata?['name'],
                                getEmail: getdata?['email'],
                              ));
                            },
                          );
                        }
                        return ListTile(
                          title: Text(
                            '회원정보 수정',
                            style: AppTextStyle.koBody2.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 18.sp,
                            color: AppColors.grey[500],
                          ),
                          onTap: () {},
                        );
                      },
                    ),

                    Divider(
                      thickness: 5,
                      color: AppColors.grey[200],
                    ),
                    ListTile(
                      title: Text(
                        '통화기록',
                        style: AppTextStyle.koBody2.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18.sp,
                        color: AppColors.grey[500],
                      ),
                      onTap: () {
                        Get.to(
                          CallHistory(),
                          transition: Transition.rightToLeft,
                        );
                      },
                    ),
                    Divider(
                      color: AppColors.grey[400],
                    ),
                    ListTile(
                      title: Text(
                        '받은 감사편지 ',
                        style: AppTextStyle.koBody2.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18.sp,
                        color: AppColors.grey[500],
                      ),
                      onTap: () {
                        Get.to(const ThankyouLetters());
                      },
                    ),
                    Divider(
                      color: AppColors.grey[400],
                    ),
                    ListTile(
                      title: Text(
                        '랭킹',
                        style: AppTextStyle.koBody2.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18.sp,
                        color: AppColors.grey[500],
                      ),
                      onTap: () {
                        Get.to(() => const Ranking_Page());
                      },
                    ),
                    Divider(
                      thickness: 5,
                      color: AppColors.grey[200],
                    ),
                    ListTile(
                      title: Text(
                        '공지사항',
                        style: AppTextStyle.koBody2.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18.sp,
                        color: AppColors.grey[500],
                      ),
                      onTap: () {
                        Get.snackbar("공지사항 준비중입니다.", "원활한 소통을 위해 준비중입니다.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColors.primaryColor,
                            colorText: Colors.white);
                        // Get.to(() => Instruction());
                      },
                    ),
                    Divider(
                      color: AppColors.grey[400],
                    ),
                    ListTile(
                      title: Text(
                        '1:1 문의',
                        style: AppTextStyle.koBody2.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18.sp,
                        color: AppColors.grey[500],
                      ),
                      onTap: () {
                        Get.to(() => Question());
                      },
                    ),
                    Divider(
                      color: AppColors.grey[400],
                    ),
                    ListTile(
                      title: Text(
                        '사용설명서',
                        style: AppTextStyle.koBody2.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18.sp,
                        color: AppColors.grey[500],
                      ),
                      onTap: () {
                        Get.to(() => const guidePage());
                      },
                    ),
                    Divider(
                      color: AppColors.grey[400],
                    ),
                    ListTile(
                      title: Text(
                        '리뷰 쓰러가기',
                        style: AppTextStyle.koBody2.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18.sp,
                        color: AppColors.grey[500],
                      ),
                      onTap: () {
                        Timer(const Duration(seconds: 2), () {
                          _ratingService.isSecondTimeOpen().then((secondOpen) {
                            if (!secondOpen) {
                              _ratingService.showRating();
                              // print("$secondOpen");
                            }
                          });
                        });
                      },
                    ),
                    Divider(
                      color: AppColors.grey[400],
                    ),
                    ListTile(
                      title: Text(
                        '라이큐 공유',
                        style: AppTextStyle.koBody2.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18.sp,
                        color: AppColors.grey[500],
                      ),
                      onTap: () {
                        Get.to(() => Instruction());
                      },
                    ),
                    Divider(
                      thickness: 5,
                      color: AppColors.grey[200],
                    ),
                    ListTile(
                      title: Text(
                        '앱 설정',
                        style: AppTextStyle.koBody2.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18.sp,
                        color: AppColors.grey[500],
                      ),
                      onTap: () {
                        Get.to(() => appSettingPage());
                      },
                    ),
                    // SizedBox(
                    //   height: 80.h,
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
