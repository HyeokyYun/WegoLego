import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:livq/config.dart';
import 'package:livq/controllers/auth_controller.dart';
import 'package:livq/push_notification/push_notification.dart';
import 'package:livq/screens/channels/channel_list.dart';
import 'package:livq/screens/home/agora/pages/call_taker.dart';
import 'package:livq/screens/home/buttons/animated_radial_menu.dart';
import 'package:livq/screens/my_page/sub_pages/guide_page.dart';
import 'package:livq/screens/home/sub_category.dart';
import 'package:livq/screens/my_page/sub_pages/ranking.dart';
import 'package:livq/screens/my_page/sub_pages/thanks_letters.dart';
import 'package:livq/screens/root.dart';
import 'package:livq/screens/sign_in/sign_in.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';
import 'package:livq/widgets/firebaseAuth.dart';
import 'package:livq/widgets/rounded_elevated_button.dart';
import 'package:livq/widgets/rounded_text_formfield.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthClass _auth = AuthClass();

  final _channelController = TextEditingController();

  final TextEditingController _categoryController = TextEditingController();
  late int askCount;

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _authController = Get.find<AuthController>();
    Get.put(ButtonController());
    FirebaseFirestore.instance
        .collection("askCount")
        .doc("askCount")
        .get()
        .then((DocumentSnapshot ds) {
      askCount = ds["count"];
      print(askCount);
    });

    Stream<QuerySnapshot> _usersStream =
        FirebaseFirestore.instance.collection('users').snapshots();

    Stream<DocumentSnapshot> _askCountStream = FirebaseFirestore.instance
        .collection('askCount')
        .doc('askCount')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          "assets/app_bar/appBar.svg",
          height: 27.h,
        ),
        elevation: 0.0,
        centerTitle: false,
        backgroundColor: Color(0xffF8F9FA),
      ),
      body: Container(
        color: Color(0xffF8F9FA),
        child: Stack(children: [
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Text("세상의 모든 인재들이 모인 공간",
                    style: AppTextStyle.koHeadline3
                        .copyWith(color: AppColors.grey[600])),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              "참여 중인 답변자",
                              style: AppTextStyle.koBody2
                                  .copyWith(color: Colors.black),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: _usersStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    "${snapshot.data?.docs.length}명",
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      // fontWeight: FontWeight.bold,
                                      color: Color(0xffF57F17),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          width: 42.w,
                        ),
                        Column(
                          children: [
                            Text(
                              "진행 중인 질의응답",
                              style: AppTextStyle.koBody2
                                  .copyWith(color: Colors.black),
                            ),
                            StreamBuilder<DocumentSnapshot>(
                              stream: _askCountStream,
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                final getdata = snapshot.data;
                                if (snapshot.hasData) {
                                  return Text(
                                    '${getdata?["count"]}건',
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      // fontWeight: FontWeight.bold,
                                      color: AppColors.secondaryColor[500],
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 300.h,
                  ),
                  Icon(Icons.arrow_drop_up, color: Color(0xffADB5BD)),
                  Icon(Icons.arrow_drop_up, color: Color(0xffADB5BD)),
                  Text('고민말고 도움을 요청하세요!',
                      style: AppTextStyle.koCaption12
                          .copyWith(color: AppColors.grey[600])),
                  SizedBox(
                    height: 30.h,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Container(
                  //       height: 59.h,
                  //       width: 151.w,
                  //       child: ElevatedButton(
                  //         onPressed: () {
                  //           //Get.to(guidePage());
                  //           Get.to(const ThankyouLetters());
                  //         },
                  //         child: Text(
                  //           "받은 감사편지 ",
                  //           style: AppTextStyle.koBody2
                  //               .copyWith(color: AppColors.grey[800]),
                  //         ),
                  //         style: ElevatedButton.styleFrom(
                  //           primary: Color(0xffFFFFFF),
                  //           //padding: EdgeInsets.all(20),
                  //           shape: new RoundedRectangleBorder(
                  //             borderRadius: new BorderRadius.circular(20.0),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(width: 15.w),
                  //     Container(
                  //       height: 59.h,
                  //       width: 151.w,
                  //       child: ElevatedButton(
                  //         onPressed: () {
                  //           Get.to(Ranking_Page());
                  //         },
                  //         child: Text(
                  //           "랭킹",
                  //           style: AppTextStyle.koBody2
                  //               .copyWith(color: AppColors.grey[800]),
                  //         ),
                  //         style: ElevatedButton.styleFrom(
                  //           primary: Color(0xffFFFFFF),
                  //           // padding: EdgeInsets.all(20),
                  //           shape: new RoundedRectangleBorder(
                  //             borderRadius: new BorderRadius.circular(20.0),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 180.h,
                  ),
                  // Container(
                  //   height: 200.h,
                  //   width: 200.w,
                  //   child: FloatingActionButton(
                  //     child: CircleAvatar(
                  //       radius: 100.w,
                  //       child: ClipOval(
                  //         child: SvgPicture.asset(
                  //           "assets/home/icon1.svg",
                  //           height: 200.h,
                  //           width: 200.w,
                  //         ),
                  //       ),
                  //     ),
                  //     onPressed: () async {
                  //       FlutterDialog("");
                  //     },
                  //   ),
                  // ),
                  // SizedBox(height: 30.h),
                  Container(
                    width: 350.w,
                    height: 350.h,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: _friendsWidget(),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  RoundedElevatedButton(
                    title: "전문가 연결",
                    onPressed: () {
                      FlutterDialog("");
                    },
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void FlutterDialog(String friendUid) {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            backgroundColor: AppColors.grey[800],
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                Text(
                  "구체적인 도움을 적어주세요:)",
                  style: AppTextStyle.koBody1.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            //
            content: Container(
              height: 100.h, //88
              width: 400.w, //254
              padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 10.h),
              decoration: BoxDecoration(
                color: Color(0xffC4C4C4),
                borderRadius: BorderRadius.circular(22),
              ),
              child: TextFormField(
                controller: _categoryController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                // obscureText: obsecureText!,
                autofocus: false,

                decoration: InputDecoration(
                  //        hintText: "구체적인 도움을 적어주세요:)",
                  hintStyle: AppTextStyle.koBody2,
                  fillColor: Colors.black,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
                // validator: validator,
              ),
            ),
            actions: <Widget>[
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        String? helperUid;

                        FirebaseFirestore.instance
                            .collection("videoCall")
                            .doc(_auth.uid)
                            .set({
                          "count": 1,
                          "timeRegister":
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          "uid": _auth.uid,
                          "name": _auth.name,
                          "subcategory": _categoryController.text
                        });

                        //monitoring
                        FirebaseFirestore.instance
                            .collection("monitoring")
                            .doc("category")
                            .update({
                          "category":
                              FieldValue.arrayUnion([_categoryController.text]),
                        });

                        FirebaseFirestore.instance
                            .collection("askCount")
                            .doc("askCount")
                            .update({"count": FieldValue.increment(1)});

                        await NotificationService.sendNotification(
                          "${_auth.name} Need Your Help!",
                          // _categoryController.text == ""
                          //     ? ""
                          //     :
                          "${_categoryController.text}",
                          friendUid,
                        );
                        await _handleCameraAndMic(Permission.camera);
                        await _handleCameraAndMic(Permission.microphone);
                        // push video page with given channel name
                        String channel = FirebaseAuth.instance.currentUser!.uid;
                        await Get.offAll(() => CallPage_taker(
                              channelName: channel,
                              // getTitle: widget.getTitle,
                            ));
                      },
                      child: Text(
                        "연결",
                        style: AppTextStyle.koBody2
                            .copyWith(color: AppColors.grey),
                      ),
                      style: ElevatedButton.styleFrom(
                        //  padding: EdgeInsets.all(10.sp),
                        primary: Colors.white,
                        fixedSize: Size(120.w, 43.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  Widget _friendsWidget() {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemExtent: 80,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        ListTile(
                          //Icon(Icons.person,color: Colors.black54,),
                          title: Row(
                            children: [
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                snapshot.data!.docs[index]['name'],
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.call),
                            color: Colors.green,
                            onPressed: () {
                              //해당 유저로 알람이 갈 수 있게
                              print(snapshot.data!.docs[index]['name']);
                              FlutterDialog(snapshot.data!.docs[index]['uid']);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Divider(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                });
          } else {
            return Container();
          }
        });
  }
}
