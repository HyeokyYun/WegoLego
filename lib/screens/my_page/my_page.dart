import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:livq/screens/my_page/my_setting_page.dart';
import 'package:livq/screens/my_page/sub_pages/1:1_question.dart';
import 'package:livq/screens/my_page/sub_pages/individual_information.dart';
import 'package:livq/screens/my_page/sub_pages/instruction_manual.dart';
import 'package:livq/screens/my_page/sub_pages/review.dart';
import 'package:livq/screens/my_page/sub_pages/statechange.dart';
import 'package:livq/screens/my_page/sub_pages/terms_and_conditions.dart';
import 'package:livq/screens/my_page/sub_pages/thanks_letters.dart';
import 'package:livq/screens/navigation_bar.dart';
import 'package:livq/screens/root.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';
import 'dart:async';

//import 'package:livq/screens/my_page/myId.dart';
class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  final TextEditingController _feedbackController = TextEditingController();
  final RatingService _ratingService = RatingService();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .snapshots();

    FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser!.uid)
        .get()
        .then((DocumentSnapshot ds) {
      if (ds['ask'] >= 10) {
        if (ds['feedback'] == false) {
          Get.defaultDialog(
            title: "라이큐 후기를 남겨주세요!",
            content: Column(
              children: [
                Text(
                  "라이큐에 대해 의견을 남겨주세요!\n위고레고 팀에게 큰 도움이 됩니다!",
                  style: AppTextStyle.koBody2,
                ),
                TextField(
                  controller: _feedbackController,
                ),
              ],
            ),
            onConfirm: () {
              FirebaseFirestore.instance
                  .collection("monitoring")
                  .doc("feedback")
                  .update({
                'feedback': FieldValue.arrayUnion([_feedbackController.text])
              });
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(firebaseUser!.uid)
                  .update({
                'feedback': true,
              });
              Get.offAll(Navigation());
              Get.snackbar("제출해주셔서 감사합니다.", "감사합니다.");
            },
            buttonColor: AppColors.primaryColor,
            textConfirm: "제출",
            confirmTextColor: AppColors.grey[50],
          );
        }
      }
    });

    return StreamBuilder<DocumentSnapshot>(
        stream: _usersStream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            Get.snackbar('Error occurred!', "Can't read your user data",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.primaryColor,
                colorText: Colors.white);
            Get.offAll(Root());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final getdata = snapshot.data;
          Stream<DocumentSnapshot> _thankStream = FirebaseFirestore.instance
              .collection('users')
              .doc(firebaseUser!.uid)
              .collection('thankLetter')
              .doc(firebaseUser!.uid)
              .snapshots();

          return StreamBuilder<DocumentSnapshot>(
            stream: _thankStream,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> subsnapshot) {
              final getsubdata = subsnapshot.data;
              if (subsnapshot.hasError) {
                Get.snackbar('Error occurred!', "Can't read your user data",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.primaryColor,
                    colorText: Colors.white);
                Get.offAll(Root());
              }
              if (subsnapshot.connectionState == ConnectionState.waiting) {
                // return splashWidget();
                return myPageWidget(
                    context,
                    "",
                    "",
                    "https://firebasestorage.googleapis.com/v0/b/wegolego-bf94b.appspot.com/o/liveQ_logo.jpg?alt=media&token=8b719a18-60db-4124-ae5e-01a5375d6a1c",
                    0,
                    0,
                    0);
              }

              return myPageWidget(
                  context,
                  getdata!["name"],
                  getdata["email"],
                  getdata["photoURL"],
                  getsubdata!['thankLetter'].length,
                  getdata["help"],
                  getdata["ask"]);
            },
          );
        });
  }

  Widget myPageWidget(
    BuildContext context,
    // bool loading,
    String name,
    String email,
    String photoURL,
    int getHeart,
    int helpCount,
    int askCount,
  ) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "마이 페이지",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Get.to(mySettingPage(
                  getName: name,
                  getEmail: email,
                ));
              },
              icon: Icon(
                Icons.settings_sharp,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(28, 0, 28, 0),
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50.h,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(57),
                  child: Image.network(
                    photoURL,
                    height: 114.h,
                    width: 114.w,
                    fit: BoxFit.scaleDown,
                  ),
                  // Image.network(
                  //   "https://drive.google.com/uc?export=view&id=1YZyTxIshyloO3YvQhMH5g4fSiIXOfM4m",
                  //   height: 114.h,
                  //   width: 114.w,
                  //   fit: BoxFit.fill,
                  // ),
                ),
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
                      decoration: BoxDecoration(
                        color: Color(0xFFFBC02D),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.purple[800],
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '님',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
                  decoration: BoxDecoration(
                    // color: AppColors.grey[50],
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
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
                                    Text(
                                      "$getHeart",
                                      style: TextStyle(
                                        fontSize: 9.sp,
                                        color: Color(0xFFF57F17),
                                      ),
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
                      Container(
                        width: 100.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
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
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "$helpCount",
                                      style: TextStyle(
                                          fontSize: 9.sp,
                                          color: Color(0xFFF57F17)),
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
                      Container(
                        width: 100.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
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
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "$askCount",
                                      style: TextStyle(
                                          fontSize: 9.sp,
                                          color: Color(0xFFF57F17)),
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
                    ListTile(
                      title: Text(
                        '받은 감사 편지 보기',
                        style: AppTextStyle.koBody2.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18.sp,
                        color: Color(0xffADB5BD),
                      ),
                      onTap: () {
                        Timer(const Duration(seconds: 2), () {
                          _ratingService.isSecondTimeOpen().then((secondOpen) {
                            if (!secondOpen) {
                              _ratingService.showRating();
                              print("$secondOpen");
                            }
                          });
                        });
                        //Get.to(guidePage());
                        // LaunchReview.launch(
                        //     androidAppId: "com.anew.flutter_final_livq",
                        //     iOSAppId: '33443434');
                      },
                    ),
                    Divider(
                      color: AppColors.grey[400],
                    ),
                    ListTile(
                      title: Text(
                        '홍보영상',
                        style: AppTextStyle.koBody2.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 18.sp,
                        color: Color(0xffADB5BD),
                      ),
                      onTap: () {
                        Get.to(() => Instruction());
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
                        color: Color(0xffADB5BD),
                      ),
                      onTap: () {
                        Get.to(() => RatingService());
                      },
                    ),
                    Divider(
                      color: AppColors.grey[400],
                    ),
                    ListTile(
                      title: Text(
                        '앱 버전 정보',
                        style: AppTextStyle.koBody2.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      trailing: Text("1.0.0",
                          style: TextStyle(
                              color: Color(0xffADB5BD), fontSize: 14.sp)),
                      onTap: () {
                        Get.snackbar('도움이 필요할땐 라이큐', "오늘도 이용해 주셔서 감사합니다.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColors.primaryColor,
                            colorText: Colors.white);
                      },
                    ),
                    Divider(
                      color: AppColors.grey[400],
                    ),
                    SizedBox(
                      height: 80.h,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

/*
child: ListView.builder(
  padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
  itemCount: 6,
  itemBuilder: (BuildContext context, int index) {
    return _buildListView(context, index);
  },
),
*/

/*
Container(
  height: ScreenUtil().setHeight(450),
  child: ListView.builder(
    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
    itemCount: 6,
    itemBuilder: (BuildContext context, int index) {
      return _buildListView(context, index);
    },
  ),
),
SizedBox(
  height: 100.h,
),

*/

Widget _buildListView(BuildContext context, int index) {
  final List<String> _list = [
    '계정 / 정보 관리',
    '1:1 문의',
    '내가 쓴 게시물 모아보기',
    '활동 상태 변경하기',
    '이용약관',
    '앱버전 정보',
  ];

  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          // leading: Text(_list[index]),
          title: Text(
            _list[index],
            style: TextStyle(color: AppColors.grey[900], fontSize: 14.sp),
            //style: body14Style(),
          ),
          trailing: index != 5
              ? Icon(
                  Icons.arrow_forward_ios,
                  size: 18.sp,
                  color: Color(0xffADB5BD),
                )
              : Text("0.2.4",
                  style: TextStyle(color: Color(0xffADB5BD), fontSize: 14.sp)),

          onTap: () async {
// begin of all IF statements
            if (index == 0) {
              await Get.to(() => StateChange());
            }
            if (index == 1) {
              await Get.to(() => Question());
            }
            if (index == 2) {
              await Get.to(() => Instruction());
            }
            if (index == 3) {
              await Get.to(() => Information());
            }
            if (index == 4) {
              await Get.to(() => Terms());
            }
            if (index == 5) {}
// end of all If statements
          },
        ),
        Divider(
          color: AppColors.grey[400],
        ),
      ],
    ),
  );
}
