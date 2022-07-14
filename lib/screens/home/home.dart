import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:livq/push_notification/push_notification.dart';
import 'package:livq/screens/home/buttons/animated_radial_menu.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';
import 'package:livq/widgets/firebaseAuth.dart';
import 'package:livq/widgets/rounded_elevated_button.dart';

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
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xffF8F9FA),
          child: Padding(
            padding: const EdgeInsets.all(27.0),
            child: Stack(children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sizedBoxWidget(0, 20),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/liveQ_logo.svg",
                          width: 30.w,
                          height: 39.h,
                        ),
                      ],
                    ),
                    _sizedBoxWidget(0, 17),
                    Stack(
                      children: [
                        Column(
                          children: [
                            _sizedBoxWidget(0, 36),
                            Opacity(
                              opacity: 0.3,
                              child: Container(
                                height: 8.h,
                                width: 64.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xffFFA300),
                                ),
                              ),
                            ),
                          ],
                        ),
                        _textWidget(
                            "안녕하세요 큐님 \n궁금증 해결이 필요한 상태군요!",
                            TextStyle(
                                fontSize: 13.sp, color: Color(0xff4D4D4D))),
                      ],
                    ),
                    _sizedBoxWidget(0, 28),
                    _textWidget("해결할 곳 없을 때,\n바로바로 물어보세요",
                        TextStyle(fontSize: 23.sp, color: Colors.black)),
                    _sizedBoxWidget(0, 16),
                    _textWidget("친구 23명",
                        TextStyle(fontSize: 16.sp, color: Colors.black)),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Column(
                    //           children: [
                    //             _textWidget( "참여 중인 답변자", AppTextStyle.koBody2
                    //                 .copyWith(color: Colors.black)),
                    //             StreamBuilder<QuerySnapshot>(
                    //               stream: _usersStream,
                    //               builder: (context, snapshot) {
                    //                 if (snapshot.hasData) {
                    //                   return Text(
                    //                     "${snapshot.data?.docs.length}명",
                    //                     style: TextStyle(
                    //                       fontSize: 22.sp,
                    //                       // fontWeight: FontWeight.bold,
                    //                       color: Color(0xffF57F17),
                    //                     ),
                    //                   );
                    //                 } else {
                    //                   return Container();
                    //                 }
                    //               },
                    //             )
                    //           ],
                    //         ),
                    //
                    //         Column(
                    //           children: [
                    //             Text(
                    //               "진행 중인 질의응답",
                    //               style: AppTextStyle.koBody2
                    //                   .copyWith(color: Colors.black),
                    //             ),
                    //             StreamBuilder<DocumentSnapshot>(
                    //               stream: _askCountStream,
                    //               builder: (context,
                    //                   AsyncSnapshot<DocumentSnapshot> snapshot) {
                    //                 final getdata = snapshot.data;
                    //                 if (snapshot.hasData) {
                    //                   return Text(
                    //                     '${getdata?["count"]}건',
                    //                     style: TextStyle(
                    //                       fontSize: 22.sp,
                    //                       // fontWeight: FontWeight.bold,
                    //                       color: AppColors.secondaryColor[500],
                    //                     ),
                    //                   );
                    //                 } else {
                    //                   return Container();
                    //                 }
                    //               },
                    //             )
                    //           ],
                    //         )
                    //       ],
                    //     ),
                    //   ],
                    // ),

                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 329.w,
                            height: 336.h,
                            child: _friendsWidget(),
                          ),
                          _sizedBoxWidget(0, 17),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _textWidget(
                                  "친구들에게 연결이 안되는 상황이라면?",
                                  TextStyle(
                                      fontSize: 12.sp,
                                      color: Color(0xffFFA300))),
                            ],
                          ),
                          _sizedBoxWidget(0, 8),
                          SizedBox(
                            width: 330.w,
                            height: 56.h,
                            child: ElevatedButton(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "전문가 도움요청하기",
                                    style: TextStyle(fontSize: 18.sp),
                                  ),
                                  Icon(Icons.arrow_forward_ios),
                                ],
                              ),
                              onPressed: () {
                                FlutterDialog("");
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xffFFA300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                          _sizedBoxWidget(0, 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 15.h,
                                    width: 15.w,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Color(0xffFFFDE7),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Container(
                                    height: 15.h,
                                    width: 15.w,
                                    child: Image.asset(
                                      "assets/home/speaker.png",
                                    ),
                                  ),
                                ],
                              ),
                              _sizedBoxWidget(2, 0),
                              _textWidget(
                                  "일주일 동안 무료로 전문가에게 질문해 보세요!",
                                  TextStyle(
                                      fontSize: 12.sp,
                                      color: Color(0xff4D4D4D))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
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
              height: 100.h,
              //88
              width: 400.w,
              //254
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
                        // await Get.offAll(() => CallPage_taker(
                        //       channelName: channel,
                        //       // getTitle: widget.getTitle,
                        //     )
                        // );
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
                    _sizedBoxWidget(0, 15),
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

  Widget friendNameWidget(String uid) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.data()['name']);
          }
          return Text("return");
        });
  }

  Widget friendPhotoWidget(String uid) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(57),
              child: Image.network(
                "${snapshot.data!.data()['photoURL']}",
                height: 37.h,
                width: 33.w,
                fit: BoxFit.fill,
              ),
            );
          }
          return Text("return");
        });
  }

  Widget _friendsWidget() {
    return FutureBuilder(
        future:
            FirebaseFirestore.instance.collection('users').doc(_auth.uid).get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            var data = snapshot.data.data();
            var friend = data['frienduid'];
            return ListView.builder(
                itemExtent: 80,
                //itemCount: snapshot.data.docs.length,
                itemCount: friend.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        //Icon(Icons.person,color: Colors.black54,),
                        title: Row(
                          children: [
                            friendPhotoWidget(friend[index].toString()),
                            _sizedBoxWidget(5, 0),
                            friendNameWidget(friend[index].toString()),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            print(snapshot.data!.docs[index]['name']);
                            FlutterDialog(snapshot.data!.docs[index]['uid']);
                          },
                          child: Text(
                            "연결하기",
                            style:
                                TextStyle(fontSize: 12.sp, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            //  padding: EdgeInsets.all(10.sp),
                            elevation: 0,
                            primary: Color(0xffFFA300),
                            fixedSize: Size(73.w, 27.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                });
          } else {
            return Container();
          }
        });
  }
}

Widget _textWidget(String string, TextStyle style) {
  return Text(
    string,
    style: style,
  );
}

Widget _sizedBoxWidget(int width, int height) {
  return SizedBox(
    width: width.w,
    height: height.h,
  );
}

Widget _dividerWidget(int height) {
  return Divider(
    height: height.h,
  );
}
