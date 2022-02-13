import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';
import 'package:flutter_switch/flutter_switch.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({Key? key}) : super(key: key);

  @override
  State<NotificationSetting> createState() => _NotificationSetting();
}

class _NotificationSetting extends State<NotificationSetting> {
  late bool status;

  FirebaseAuth auth = FirebaseAuth.instance;
  User? get userProfile => auth.currentUser;
  User? currentUser;

  @override
  void initState() {
    final userData =
        FirebaseFirestore.instance.collection('users').doc(currentUser!.uid);
    userData.get().then((value) => {status = value['NotificationOn']});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          color: AppColors.grey,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "알림 설정",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 0.0, 12.w, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "알림 수신",
                      style: AppTextStyle.koBody1,
                    ),
                    FlutterSwitch(
                      width: 48.w,
                      height: 30.w,
                      onToggle: (val) {
                        setState(() {
                          status = val;
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(userProfile!.uid)
                              .update({'NotificationOn': status});
                        });
                      },
                      value: status,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
