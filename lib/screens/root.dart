import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livq/controllers/auth_controller.dart';
import 'package:livq/screens/navigation/bottom_navigation.dart';
import 'package:livq/screens/sign_up/sign_up.dart';
import 'package:livq/screens/welcome_page.dart';
import '../screens/sign_in/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config.dart';
import 'home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'sign_up/update.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  User? user;
  late bool isSign;

  FirebaseAuth auth = FirebaseAuth.instance;

  User? get userProfile => auth.currentUser;

  @override
  void initState() {
    //새로운 버전 수정 전 반드시 수정 필요

    super.initState();
    FirebaseAuth.instance
        .authStateChanges()
        .listen((event) => updateUserState(event));
    // FirebaseFirestore.instance.collection("versions").
    isSign = false;
  }

  updateUserState(event) {
    user = event;
    if (user == null) {
      isSign = false;
    } else {
      isSign = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);

    return GetBuilder<AuthController>(
      builder: (_) {
        return isSign
            ? _.isAvailable.value
                ? _.isFirstSignIn.value
                    ? _.isEmailSignIn.value
                        ? WelcomePage()
                        : SignUp()
                    : BottomNavigation()
                : UpdateWidget()
            : Scaffold(
                body: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Config.screenWidth! * 0.0),
                    child: SignIn(),
                  ),
                ),
              );
      },
    );
  }
}
