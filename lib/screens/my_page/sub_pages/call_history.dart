import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:livq/screens/my_page/my_page.dart';
import 'package:livq/screens/navigation/bottom_navigation.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';

class CallHistory extends StatefulWidget {
  @override
  State<CallHistory> createState() => _CallHistoryState();
}

class _CallHistoryState extends State<CallHistory> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  /*
 
   */

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .collection('callHistory')
        .orderBy("timeRegister", descending: true)
        .snapshots();
    final TextEditingController _reportController = TextEditingController();
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "통화기록",
                  style: TextStyle(color: Colors.black),
                ),
                elevation: 0.0,
                backgroundColor: Colors.white,
                centerTitle: true,
                leading: IconButton(
                  color: AppColors.grey,
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Get.back();
                    // Get.off(
                    //   BottomNavigation(),
                    //   transition: Transition.leftToRightWithFade,
                    // );
                  },
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "통화기록",
                style: TextStyle(color: Colors.black),
              ),
              elevation: 0.0,
              backgroundColor: Colors.white,
              centerTitle: true,
              leading: IconButton(
                color: AppColors.grey,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Get.back();
                  // Get.off(
                  //   BottomNavigation(),
                  //   transition: Transition.leftToRightWithFade,
                  // );
                },
              ),
            ),
            body: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        child: ListView(
                          padding: const EdgeInsets.all(20),
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            String docId = document.id;
                            return Card(
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(10.0.w)),
                              elevation: 10.0,
                              shadowColor: AppColors.grey[100],
                              color: Color(0xffF1F3F5),
                              child: Container(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  child: Container(
                                    // height:
                                    //Config.screenHeight! * 0.103,
                                    width: 340.w,
                                    //Config.screenWidth! * 0.322,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 200.w,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 150.w,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            data['isHelper']
                                                                ? "도와 받은 사람 : "
                                                                : "도와준 사람 : ",
                                                            style: AppTextStyle
                                                                .koBody1,
                                                          ),
                                                          Text(
                                                            data['name'],
                                                            style: AppTextStyle
                                                                .koBody1,
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                          child: Text(
                                                        "질문 : " +
                                                            data['question'],
                                                        style: AppTextStyle
                                                            .koBody2,
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 80.w,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 50.h,
                                                ),
                                                Container(
                                                  width: 60.w,
                                                  child: TextButton(
                                                    child: Text(
                                                      data['report']
                                                          ? "신고함"
                                                          : "신고하기",
                                                      //data['uid'],
                                                      style: AppTextStyle
                                                          .koButton
                                                          .copyWith(
                                                        color:
                                                            AppColors.grey[50],
                                                      ),
                                                    ),
                                                    style: TextButton.styleFrom(
                                                      backgroundColor:
                                                          data['report']
                                                              ? AppColors
                                                                  .grey[500]
                                                              : Colors.red,
                                                      shape:
                                                          new RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          22.0)),
                                                    ),
                                                    onPressed: () {
                                                      data['report']
                                                          ? Get.snackbar(
                                                              "이미 신고되었습니다.",
                                                              "유저의 일정이상 신고가 반복되면 신고된 유저는 차단됩니다.",
                                                              snackPosition:
                                                                  SnackPosition
                                                                      .BOTTOM,
                                                              backgroundColor:
                                                                  AppColors
                                                                      .primaryColor,
                                                              colorText:
                                                                  Colors.white,
                                                            )
                                                          : showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  true,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10.0)),
                                                                  backgroundColor:
                                                                      AppColors
                                                                              .grey[
                                                                          800],
                                                                  //Dialog Main Title
                                                                  title: Column(
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        "신고 하고 싶은 내용을 적어주세요",
                                                                        style: AppTextStyle
                                                                            .koBody1
                                                                            .copyWith(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  //
                                                                  content:
                                                                      Container(
                                                                    height: 100
                                                                        .h, //88
                                                                    width: 300
                                                                        .w, //254
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            15.w,
                                                                            10.h,
                                                                            15.w,
                                                                            10.h),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xffC4C4C4),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              22),
                                                                    ),
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          _reportController,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .multiline,
                                                                      maxLines:
                                                                          null,
                                                                      // obscureText: obsecureText!,
                                                                      autofocus:
                                                                          false,

                                                                      decoration:
                                                                          InputDecoration(
                                                                        //        hintText: "구체적인 도움을 적어주세요:)",
                                                                        hintStyle:
                                                                            AppTextStyle.koBody2,
                                                                        fillColor:
                                                                            Colors.black,
                                                                        focusedBorder:
                                                                            InputBorder.none,
                                                                        enabledBorder:
                                                                            InputBorder.none,
                                                                        errorBorder:
                                                                            InputBorder.none,
                                                                        focusedErrorBorder:
                                                                            InputBorder.none,
                                                                      ),
                                                                      // validator: validator,
                                                                    ),
                                                                  ),
                                                                  actions: <
                                                                      Widget>[
                                                                    Center(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          ElevatedButton(
                                                                            onPressed:
                                                                                () async {
                                                                              //report false로 바꾸고
                                                                              FirebaseFirestore.instance.collection('users').doc(firebaseUser!.uid).collection("callHistory").doc(docId).update({
                                                                                "report": true,
                                                                              });

                                                                              //모니터링에 신고 내용 작성
                                                                              //새로운 collection에 랜덤으로 생성
                                                                              FirebaseFirestore.instance.collection("report").add({
                                                                                "timeRegister": DateTime.now().millisecondsSinceEpoch.toString(),
                                                                                "reportContent": _reportController.text,
                                                                                "reportedUserName": data["name"],
                                                                                "reportedUserUid": data["uid"],
                                                                              });

                                                                              Get.offAll(BottomNavigation());

                                                                              Get.snackbar(
                                                                                "신고되었습니다.",
                                                                                "유저의 일정이상 신고가 반복되면 신고된 유저는 차단됩니다.",
                                                                                snackPosition: SnackPosition.BOTTOM,
                                                                                backgroundColor: AppColors.primaryColor,
                                                                                colorText: Colors.white,
                                                                              );
                                                                            },
                                                                            child:
                                                                                Text(
                                                                              "신고하기",
                                                                              style: AppTextStyle.koBody2.copyWith(color: AppColors.grey),
                                                                            ),
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              //  padding: EdgeInsets.all(10.sp),
                                                                              primary: Colors.white,
                                                                              fixedSize: Size(120.w, 43.h),
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(15),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                15.h,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ]),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          // children: _buildGridCards(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            resizeToAvoidBottomInset: false,
          );
        });
  }
}
