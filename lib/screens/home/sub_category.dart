import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:livq/push_notification/push_notification.dart';
import 'package:livq/screens/home/agora/pages/call_taker.dart';
import 'package:livq/screens/navigation/bottom_navigation.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';
import 'package:permission_handler/permission_handler.dart';

import 'buttons/animated_radial_menu.dart';

class SubCategory extends StatefulWidget {
  // const SubCategory({Key? key, required this.getTitle, required this.getIndex})
  //     : super(key: key);
  // final String getTitle;
  // final int getIndex;
  @override
  _SubCategoryState createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  TextEditingController _categoryController = TextEditingController();
  final List<String> _titleList = ['대중 교통', '애완 동물', '공부', '밥', '운동', ''];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black.withOpacity(0.55),
          ),

          Center(child: thanksLetter(context))

          // Image.asset("assets/splash_page/LiveQ_logo.gif")
        ],
      ),
    );
  }

  Widget thanksLetter(BuildContext context) {
    return Container(
      width: 341.w,
      height: 337.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(33),
        color: AppColors.grey[50],
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 30.h,
          ),
          Container(
            width: 300.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  " 필요한 도움을 자세히 알려주시면 ",
                  style: AppTextStyle.koBody1.copyWith(
                    color: AppColors.grey[900],
                  ),
                ),
                Text(
                  "더 정확한 도움을 드릴 수 있어요",
                  style: AppTextStyle.koBody1.copyWith(
                    color: AppColors.primaryColor[900],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 21.h,
          ),
          Container(
            height: 100.h,
            width: 290.w,
            padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 10.h),
            decoration: BoxDecoration(
              color: AppColors.primaryColor[50],
              borderRadius: BorderRadius.circular(22),
            ),
            child: TextFormField(
              controller: _categoryController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              // obscureText: obsecureText!,
              decoration: InputDecoration(
                hintText: "구체적인 도움을 적어주세요:)",
                hintStyle: AppTextStyle.koBody2,
                fillColor: AppColors.primaryColor[50],
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
              // validator: validator,
            ),
          ),
          SizedBox(
            height: 21.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 133.w,
                height: 59.h,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Get.find<ButtonController>().changetrue();
                      Get.offAll(BottomNavigation());
                    });
                    //그냥 메인 페이지로 넘어갈 수 있게 하기
                  },
                  child: Text(
                    "취소하기",
                    style: AppTextStyle.koBody2.copyWith(color: AppColors.grey),
                  ),
                  style: ElevatedButton.styleFrom(
                    // padding: padding,
                    primary: AppColors.grey[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(33),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 22.h,
              ),
              SizedBox(
                width: 133.w,
                height: 59.h,
                child: ElevatedButton(
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

                    FirebaseFirestore.instance
                        .collection("askCount")
                        .doc("askCount")
                        .update({"count": FieldValue.increment(1)});

                    //for feddback
                    FirebaseFirestore.instance
                        .collection("monitoring")
                        .doc("category")
                        .update({
                      'category':
                          FieldValue.arrayUnion([_categoryController.text])
                    });

                    await NotificationService.sendNotification(
                        "${firebaseUser!.displayName} Need Your Help!",
                        // _categoryController.text == ""
                        //     ? ""
                        //     :
                        "${_categoryController.text}",
                        "");
                    await _handleCameraAndMic(Permission.camera);
                    await _handleCameraAndMic(Permission.microphone);
                    // push video page with given channel name
                    String channel = FirebaseAuth.instance.currentUser!.uid;
                    // await Get.offAll(() => CallPage_taker(
                    //       channelName: channel,
                    //       // getTitle: widget.getTitle,
                    //     ));
                  },
                  child: Text(
                    "연결하기",
                    style: AppTextStyle.koBody2.copyWith(color: AppColors.grey),
                  ),
                  style: ElevatedButton.styleFrom(
                    // padding: padding,
                    primary: AppColors.primaryColor[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(33),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
