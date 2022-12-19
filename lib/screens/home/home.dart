import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:livq/push_notification/push_notification.dart';
import 'package:livq/screens/home/agora/pages/call_taker.dart';
import 'package:livq/screens/home/buttons/animated_radial_menu.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';
import 'package:livq/widgets/firebaseAuth.dart';
import 'package:livq/widgets/common_widget.dart';
import 'package:permission_handler/permission_handler.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  AuthClass _auth = AuthClass();
  final _channelController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();


  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ButtonController());

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
                    sizedBoxWidget(0, 20),
                    SvgPicture.asset("assets/liveQ_logo.svg", width: 30.w, height: 39.h,),
                    sizedBoxWidget(0, 17),
                    Stack(
                      children: [
                        Column(
                          children: [
                            sizedBoxWidget(0, 36),
                            _highlight(64, 8, 0.3),
                          ],
                        ),
                        textWidget("안녕하세요 큐님 \n궁금증 해결이 필요한 상태군요!", TextStyle(fontSize: 13.sp, color: Color(0xff4D4D4D))),
                      ],
                    ),
                    sizedBoxWidget(0, 28),
                    textWidget("해결할 곳 없을 때,\n바로바로 물어보세요", TextStyle(fontSize: 23.sp, color: Colors.black)),
                    sizedBoxWidget(0, 16),
                    _countFriends(),
                    Center(
                      child: Column(
                        children: [
                          sizedBoxWithChild(329, 336, _friendsWidget()),
                          sizedBoxWidget(0, 17),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              textWidget("친구들에게 연결이 안되는 상황이라면?", TextStyle(fontSize: 12.sp, color: Color(0xffFFA300)))
                            ],
                          ),
                          sizedBoxWidget(0, 8),
                          sizedBoxWithChild(330, 56, _helpButton()),
                          sizedBoxWidget(0, 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 15.h,
                                    width: 15.w,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration( color: Color(0xffFFFDE7), shape: BoxShape.circle)),
                                   sizedBoxWithChild(15, 15, Image.asset("assets/home/speaker.png"))
                                ],
                              ),
                              sizedBoxWidget(2, 0),
                              textWidget("일주일 동안 무료로 전문가에게 질문해 보세요!", TextStyle(fontSize: 12.sp, color: Color(0xff4D4D4D))),
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
                textWidget(
                  "구체적인 도움을 적어주세요:)",
                  AppTextStyle.koBody1.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            //
            content: Container(
              height: 100.h,
              width: 400.w,
              padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 10.h),
              decoration: BoxDecoration(
                color: Color(0xffC4C4C4),
                borderRadius: BorderRadius.circular(22),
              ),
              child: TextFormField(
                controller: _categoryController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                autofocus: false,
                decoration: InputDecoration(
                  hintStyle: AppTextStyle.koBody2,
                  fillColor: Colors.black,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
              ),
            ),
            actions: <Widget>[
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
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
                          "${_categoryController.text}",
                          friendUid,
                        );
                        await _handleCameraAndMic(Permission.camera);
                        await _handleCameraAndMic(Permission.microphone);
                        String channel = FirebaseAuth.instance.currentUser!.uid;
                        await Get.offAll(() => CallPage_taker(
                              channelName: channel,
                            ));
                      },
                      child: textWidget("연결", AppTextStyle.koBody2.copyWith(color: AppColors.grey),),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        fixedSize: Size(120.w, 43.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    sizedBoxWidget(0, 15),
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
        future: FirebaseFirestore.instance.collection('users').doc(_auth.uid).get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            var data = snapshot.data.data();
            var friend = data['frienduid'];
            return ListView.builder(
                itemExtent: 80,
                itemCount: friend.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            friendPhotoWidget(friend[index].toString()),
                            sizedBoxWidget(5, 0),
                            friendNameWidget(friend[index].toString()),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            FlutterDialog(friend[index].toString());
                          },
                          child:textWidget(
                            "연결하기", TextStyle(fontSize: 12.sp, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            //  padding: EdgeInsets.all(10.sp),
                            elevation: 0,
                            primary: Color(0xffFFA300),
                            fixedSize: Size(80.w, 27.h),
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

  Widget _helpButton() {
    return ElevatedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          textWidget("전문가 도움요청하기",TextStyle(fontSize: 18.sp)),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
      onPressed: () {FlutterDialog("");},
      style: ElevatedButton.styleFrom(
        primary: Color(0xffFFA300),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _countFriends() {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('users').doc(_auth.uid).get(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          var data = snapshot.data.data();
          var friend = data['frienduid'];
          return textWidget("친구 ${friend.length.toString()}명",
              TextStyle(fontSize: 16.sp, color: Colors.black));
        }
        return Container();
      },
    );
  }
}



Widget _highlight(int width, int height, double opacity) {
  return Opacity(
    opacity: opacity,
    child: Container(
      width: width.w,
      height: height.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(0xffFFA300),
      ),
    ),
  );
}



