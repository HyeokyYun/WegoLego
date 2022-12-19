import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:livq/widgets/common_widget.dart';
import 'package:livq/widgets/firebaseAuth.dart';


class NotificationSetting extends StatefulWidget {
  const NotificationSetting({Key? key}) : super(key: key);

  @override
  State<NotificationSetting> createState() => _NotificationSetting();
}

class _NotificationSetting extends State<NotificationSetting> {
  String? _token;
  late FirebaseMessaging messaging;

  AuthClass _auth = AuthClass();

  late bool status;

  @override
  void initState() {
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      _token = value;
    });
    FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        status = documentSnapshot['notificationOn'];
      });
    });
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
          onPressed: () {Get.back();},
        ),
        title: textWidget("알림 설정", TextStyle(color: Colors.black)),
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
              sizedBoxWidget(0, 10),
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 0.0, 12.w, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textWidget("알림 수신", AppTextStyle.koBody1),
                    _toggleButton()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

  Widget _toggleButton(){
    Stream<DocumentSnapshot> _usersStream = _auth.UserStream();
    return  StreamBuilder<DocumentSnapshot>(
        stream: _usersStream,
        builder: (context,
            AsyncSnapshot<DocumentSnapshot> snapshot) {
          return FlutterSwitch(
            width: 48.w,
            height: 30.w,
            activeColor: AppColors.primaryColor,
            onToggle: (val) {
              setState(() {
                status = val;
                print("toggle status changed $status");
              });
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(_auth.uid)
                  .update({'notificationOn': val}).then(
                      (value) {
                    status
                        ? FirebaseFirestore.instance
                        .collection('users')
                        .doc(_auth.uid)
                        .update({'token': _token})
                        : FirebaseFirestore.instance
                        .collection('users')
                        .doc(_auth.uid)
                        .update(
                        {'token': "Notification Turn Off"});
                  });
            },
            value: status,
          );
        });
  }

}
