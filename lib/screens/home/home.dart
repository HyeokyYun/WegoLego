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
import 'package:livq/screens/home/guide_page.dart';
import 'package:livq/screens/home/sub_category.dart';
import 'package:livq/screens/my_page/sub_pages/ranking.dart';
import 'package:livq/screens/navigation_bar.dart';
import 'package:livq/screens/root.dart';
import 'package:livq/screens/sign_in/sign_in.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';
import 'package:livq/widgets/rounded_text_formfield.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool pressed1 = false;
  bool pressed2 = false;
  bool pressed3 = false;
  bool pressed4 = false;
  bool pressed5 = false;
  final List<String> _titleList = ['대중 교통', '애완 동물', '공부', '전자기기', '운동', ''];
  final List<String> _textList = [
    '에 대한 도움이 필요하시군요 !\n필요한 도움을 자세히 알려주시면\n 더 정확한 도움을 드릴 수 있어요',
  ];

  // int idx = -1;

  final List<IconData> _iconTypes = [
    Icons.directions_bus,
    FontAwesomeIcons.dog,
    FontAwesomeIcons.pencilAlt,
    FontAwesomeIcons.phone,
    Icons.sports_baseball,
    FontAwesomeIcons.question,
  ];

  final ClientRole? _role = ClientRole.Broadcaster;

  FirebaseAuth auth = FirebaseAuth.instance;

  User? get userProfile => auth.currentUser;
  User? currentUser;

  var firebaseUser = FirebaseAuth.instance.currentUser;
  final _channelController = TextEditingController();

  final TextEditingController _categoryController = TextEditingController();
  // final TextEditingController _feedbackController = TextEditingController();
  late int askCount;

  bool _isdark = false;

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

    print("HOME is signed in: ${_authController.isSignedIn}");

    //이 부분에 추가 함.

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
                  children: [
                    SizedBox(
                      width: 61.w,
                    ),
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
                              return CircularProgressIndicator();
                            }
                          },
                        )
                        // Text(
                        //   "${snapshot.data!.docs.length}명",
                        //   style: TextStyle(
                        //     fontSize: 22.sp,
                        //     fontWeight: FontWeight.bold,
                        //     color: Color(0xffF57F17),
                        //   ),
                        // ),
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
                              return CircularProgressIndicator();
                            }
                          },
                        )
                      ],
                    )
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
                  // style: bodyhighlightStyle(
                  //   color: Colors.black,
                  //   fontsize: 12,
                  //   height: 1.5,
                  // ),

                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 59.h,
                        width: 151.w,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(guidePage());
                          },
                          child: Text(
                            "사용설명서",
                            style: AppTextStyle.koBody2
                                .copyWith(color: AppColors.grey[800]),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xffFFFFFF),
                            //padding: EdgeInsets.all(20),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Container(
                        height: 59.h,
                        width: 151.w,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(Ranking_Page());
                          },
                          child: Text(
                            "랭킹",
                            style: AppTextStyle.koBody2
                                .copyWith(color: AppColors.grey[800]),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xffFFFFFF),
                            // padding: EdgeInsets.all(20),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
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
                    height: 200.h,
                    width: 200.w,
                    child: FloatingActionButton(
                      child: CircleAvatar(
                        radius: 100.w,
                        child: ClipOval(
                          child: SvgPicture.asset(
                            "assets/home/icon1.svg",
                            height: 200.h,
                            width: 200.w,
                          ),
                        ),
                      ),
                      // onPressed: () {
                      //   setState(() {
                      //     _isdark = true;
                      //   });
                      // }
                      onPressed: () async {
                        await Get.to(() => SubCategory(
                            // getTitle:
                            // _titleList[Get
                            //     .find<ButtonController>()
                            //     .idx],
                            // getIndex: Get
                            //     .find<ButtonController>()
                            //     .idx,
                            //  role: _role,
                            ));
                      },
                      // style: ElevatedButton.styleFrom(
                      //   shape: CircleBorder(),
                      //   padding: EdgeInsets.all(0),
                      //   primary: Colors.white, // <-- Button color
                      //   onPrimary: Colors.red, // <-- Splash color
                      // ),
                    ),
                  )
                ],
              ),
            ),
          ),
          _isdark
              ? Container(
                  child: Stack(
                    children: [
                      // Container(
                      //   color: Colors.black.withOpacity(0.55),
                      // ),
                      GestureDetector(
                        onTap: () {
                          // Get.find<ButtonController>().controllerclose();
                          setState(() {
                            //   _.changetrue();

                            Navigator.pushAndRemoveUntil(
                              context,
                              FadeRoute(
                                page: Navigation(),
                              ),
                              (route) => false,
                            );
                          });
                        },
                        child: Container(
                          width: 376.w,
                          height: 812.h,
                          color: Colors.black.withOpacity(0.55),
                        ),
                      ),

                      Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SingleChildScrollView(
                            child: Center(
                              child: Container(
                                height: 150.h,
                                width: 290.w,
                                padding:
                                    EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 10.h),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: TextFormField(
                                  controller: _categoryController,
                                  keyboardType: TextInputType.multiline,
                                  autofocus: true,
                                  cursorColor: Colors.orange,
                                  cursorWidth: 3.w,
                                  maxLines: null,
                                  style: TextStyle(height: 1.5.sp),
                                  // obscureText: obsecureText!,
                                  decoration: InputDecoration(
                                    hintText: " 필요한 도움을 자세히 적어주세요! ",
                                    hintStyle: AppTextStyle.koBody2
                                        .copyWith(color: AppColors.grey[700]),
                                    fillColor:
                                        Color(0xffC4C4C4).withOpacity(0.5),
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none,
                                  ),
                                  // validator: validator,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          SizedBox(
                            width: 133.w,
                            height: 53.h,
                            child: ElevatedButton(
                              onPressed: () async {
                                String? helperUid;

                                FirebaseFirestore.instance
                                    .collection("videoCall")
                                    .doc(firebaseUser!.uid)
                                    .set({
                                  "count": 1,
                                  "timeRegister": DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  "uid": firebaseUser!.uid,
                                  "name": firebaseUser!.displayName,
                                  // "category": "",
                                  // "index": "",
                                  "subcategory": _categoryController.text
                                });

                                // askCount = askCount + 1;
                                FirebaseFirestore.instance
                                    .collection("askCount")
                                    .doc("askCount")
                                    .update({"count": FieldValue.increment(1)});

                                await NotificationService.sendNotification(
                                    "${firebaseUser!.displayName} Need Your Help!",
                                    // _categoryController.text == ""
                                    //     ? ""
                                    //     :
                                    "${_categoryController.text}");
                                await _handleCameraAndMic(Permission.camera);
                                await _handleCameraAndMic(
                                    Permission.microphone);
                                // push video page with given channel name
                                String channel =
                                    FirebaseAuth.instance.currentUser!.uid;
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
                                // padding: padding,
                                primary: AppColors.grey[50],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     // SizedBox(
                          //     //   width: 133.w,
                          //     //   height: 53.h,
                          //     //   child: ElevatedButton(
                          //     //     onPressed: () {
                          //     //       setState(() {
                          //     //         _isdark=false;
                          //     //         // Get.find<ButtonController>().changetrue();
                          //     //         // Get.offAll(Navigation());
                          //     //       });
                          //     //       //그냥 메인 페이지로 넘어갈 수 있게 하기
                          //     //     },
                          //     //     child: Text(
                          //     //       "취소하기",
                          //     //       style: AppTextStyle.koBody2
                          //     //           .copyWith(color: AppColors.grey),
                          //     //     ),
                          //     //     style: ElevatedButton.styleFrom(
                          //     //       // padding: padding,
                          //     //       primary: AppColors.grey[200],
                          //     //       shape: RoundedRectangleBorder(
                          //     //         borderRadius: BorderRadius.circular(20),
                          //     //       ),
                          //     //     ),
                          //     //   ),
                          //     // ),
                          //     SizedBox(
                          //       width: 22.h,
                          //     ),
                          //     SizedBox(
                          //       width: 133.w,
                          //       height: 53.h,
                          //       child: ElevatedButton(
                          //         onPressed: () async {
                          //           String? helperUid;
                          //
                          //           FirebaseFirestore.instance
                          //               .collection("videoCall")
                          //               .doc(firebaseUser!.uid)
                          //               .set({
                          //             "count": 1,
                          //             "timeRegister": DateTime.now()
                          //                 .millisecondsSinceEpoch
                          //                 .toString(),
                          //             "uid": firebaseUser!.uid,
                          //             "name": firebaseUser!.displayName,
                          //             "category": "",
                          //             "index": "",
                          //             "subcategory": _categoryController.text
                          //           });
                          //
                          //           FirebaseFirestore.instance
                          //               .collection("askCount")
                          //               .doc("askCount")
                          //               .get()
                          //               .then((DocumentSnapshot ds) {
                          //             askCount = ds["count"];
                          //             print(askCount);
                          //           });
                          //           askCount = askCount + 1;
                          //           FirebaseFirestore.instance
                          //               .collection("askCount")
                          //               .doc("askCount")
                          //               .update({"count": askCount});
                          //
                          //           await NotificationService.sendNotification(
                          //               "${firebaseUser!.displayName} Need Your Help!",
                          //               _categoryController.text == ""
                          //                   ? ""
                          //                   : "${_categoryController.text}");
                          //           await _handleCameraAndMic(
                          //               Permission.camera);
                          //           await _handleCameraAndMic(
                          //               Permission.microphone);
                          //           // push video page with given channel name
                          //           String channel =
                          //               FirebaseAuth.instance.currentUser!.uid;
                          //           await Get.to(() => CallPage_taker(
                          //                 channelName: channel,
                          //                 // getTitle: widget.getTitle,
                          //               ));
                          //         },
                          //         child: Text(
                          //           "연결",
                          //           style: AppTextStyle.koBody2
                          //               .copyWith(color: AppColors.grey),
                          //         ),
                          //         style: ElevatedButton.styleFrom(
                          //           // padding: padding,
                          //           primary: AppColors.grey[50],
                          //           shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(20),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // )
                        ],
                      ))
                      // Image.asset("assets/aplash_page/LiveQ_logo.gif")
                    ],
                  ),
                )
              : Container(),

          // GetBuilder<ButtonController>(
          //     init: ButtonController(),
          //     builder: (_) {
          //       return _.dark
          //           ? Container()
          //           : Stack(
          //               children: [
          //                 GestureDetector(
          //                   onTap: () {
          //                     // Get.find<ButtonController>().controllerclose();
          //                     setState(() {
          //                       _.changetrue();
          //
          //                       Navigator.pushAndRemoveUntil(
          //                         context,
          //                         FadeRoute(
          //                           page: Navigation(),
          //                         ),
          //                         (route) => false,
          //                       );
          //                     });
          //                   },
          //                   child: Container(
          //                     width: MediaQuery.of(context).size.width,
          //                     height: MediaQuery.of(context).size.height,
          //                     color: Colors.black.withOpacity(0.8),
          //                   ),
          //                 ),
          //                 Column(
          //                   children: [
          //                     SizedBox(
          //                       height: 400.h,
          //                     ),
          //                     if (Get.find<ButtonController>().idx != 5)
          //                       Column(
          //                         children: [
          //                           Center(
          //                               child: Icon(
          //                                   _iconTypes[
          //                                       Get.find<ButtonController>()
          //                                           .idx],
          //                                   size: 32.sp,
          //                                   color: Color(0xffF9A825))),
          //                           SizedBox(
          //                             height: 12.h,
          //                           ),
          //                           Center(
          //                             child: Text(
          //                               _titleList[
          //                                   Get.find<ButtonController>().idx],
          //                               style: TextStyle(
          //                                   fontSize: 18.sp,
          //                                   color: Colors.white),
          //                             ),
          //                           ),
          //                           Center(
          //                             child: Text(
          //                               _textList[0],
          //                               //_textList[0],
          //                               style: TextStyle(
          //                                   fontSize: 12.sp,
          //                                   color: Colors.white,
          //                                   height: 2.1.h),
          //                             ),
          //                           ),
          //                           SizedBox(
          //                             height: 12.h,
          //                           ),
          //                           SizedBox(
          //                             height: 50.h,
          //                             width: 151.w,
          //                             child: ElevatedButton(
          //                               onPressed: () async {
          //                                 await Get.to(() => SubCategory(
          //                                       getTitle: _titleList[
          //                                           Get.find<ButtonController>()
          //                                               .idx],
          //                                       getIndex:
          //                                           Get.find<ButtonController>()
          //                                               .idx,
          //                                       //  role: _role,
          //                                     ));
          //                               },
          //                               child: Text(
          //                                 "연결하기",
          //                                 style: TextStyle(
          //                                     color: Color(0xff6F7378)),
          //                               ),
          //                               style: ElevatedButton.styleFrom(
          //                                 primary: Color(0xffFFFFFF),
          //                                 shape: new RoundedRectangleBorder(
          //                                   borderRadius:
          //                                       new BorderRadius.circular(20.0),
          //                                 ),
          //                               ),
          //                             ),
          //                           ),
          //                         ],
          //                       )
          //                     else
          //                       Container()
          //                   ],
          //                 )
          //               ],
          //             );
          //     }),
        ]),
      ),
    );
  }

  // @override
  // Widget UserStream(BuildContext context){
  //    return StreamBuilder<QuerySnapshot>(
  //        stream: _usersStream,
  //        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //          if (snapshot.hasError) {
  //            return Scaffold(body: const Text('Firebase Data has not received'));
  //          }
  //          if (snapshot.connectionState == ConnectionState.waiting) {
  //            return const Scaffold(body:Center(child: CircularProgressIndicator()));
  //          }});
  // }
  //
  // Widget thanksLetter(BuildContext context) {
  //   return Column(
  //     // mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       SizedBox(
  //         height: 30.h,
  //       ),
  //       Container(
  //         height: 150.h,
  //         width: 290.w,
  //         padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 10.h),
  //         decoration: BoxDecoration(
  //           color: AppColors.primaryColor[50],
  //           borderRadius: BorderRadius.circular(22),
  //         ),
  //         child: TextFormField(
  //           controller: _categoryController,
  //           keyboardType: TextInputType.multiline,
  //           maxLines: null,
  //           // obscureText: obsecureText!,
  //           decoration: InputDecoration(
  //             hintText: "필요한 도움을 자세히 알려주시면\n더 정확한 도움을 드릴 수 있어요",
  //             hintStyle: AppTextStyle.koBody2,
  //             fillColor: AppColors.primaryColor[50],
  //             focusedBorder: InputBorder.none,
  //             enabledBorder: InputBorder.none,
  //             errorBorder: InputBorder.none,
  //             focusedErrorBorder: InputBorder.none,
  //           ),
  //           // validator: validator,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

// Future<Widget> UserStream(context) async {
//   return StreamBuilder<QuerySnapshot>(
//       stream: _usersStream,
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return const Text('Firebase Data has not received');
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }});}

}

class FadeRoute extends PageRouteBuilder {
  final Widget page;

  FadeRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
