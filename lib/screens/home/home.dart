import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:livq/screens/home/agora/pages/call_taker.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';

import '../../controllers/auth_controller.dart';
import '../../firebaseAuth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthClass _auth = AuthClass();

  final _authController = Get.find<AuthController>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meta"),
      ),
      body: Obx(() {
        return _authController.isUser == false
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SignInButton(
                      buttonType: ButtonType.google,
                      onPressed: () => _authController.signInWithGoogle(),
                    ),
                    Platform.isIOS
                        ? SignInButton(
                            buttonType: ButtonType.appleDark,
                            onPressed: () => _authController.signInWithApple(),
                          )
                        : Container(),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: ElevatedButton(
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
                        });

                        await _handleCameraAndMic(Permission.camera);
                        await _handleCameraAndMic(Permission.microphone);
                        // push video page with given channel name
                        String channel = FirebaseAuth.instance.currentUser!.uid;
                        await Get.offAll(() => CallPage_taker(
                              channelName: channel,
                              // getTitle: widget.getTitle,
                            ));
                      },
                      child: Text("connect"),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          _authController.signout();
                        },
                        child: Text("logout")),
                  ),
                ],
              );
      }),
    );
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
