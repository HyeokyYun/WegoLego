import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:livq/controllers/auth_controller.dart';
import 'package:livq/push_notification/push_notification.dart';
import 'package:livq/screens/home/agora/pages/call_taker.dart';
import 'package:livq/screens/home/buttons/animated_radial_menu.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';
import 'package:livq/widgets/rounded_elevated_button.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth auth = FirebaseAuth.instance;

  User? get userProfile => auth.currentUser;
  User? currentUser;

  var firebaseUser = FirebaseAuth.instance.currentUser;
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
                            .doc(firebaseUser!.uid)
                            .set({
                          "count": 1,
                          "timeRegister":
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          "uid": firebaseUser!.uid,
                          "name": firebaseUser!.displayName,
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
                          "${firebaseUser!.displayName} Need Your Help!",
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
    CollectionReference name = FirebaseFirestore.instance.collection('users');
    return FutureBuilder(
        //future: FirebaseFirestore.instance.collection('users').get(),
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser!.uid)
            .get(),
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
                              friendPhotoWidget(friend[index].toString()),
                              friendNameWidget(friend[index].toString())
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.call),
                            color: Colors.green,
                            onPressed: () {
                              FlutterDialog(friend[index].toString());
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
