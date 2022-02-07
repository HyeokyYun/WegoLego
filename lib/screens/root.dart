import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livq/controllers/auth_controller.dart';
import 'package:livq/screens/home/agora/pages/welcome.dart';
import 'package:livq/screens/navigation_bar.dart';
import 'package:livq/screens/welcome_page.dart';
import '../screens/sign_in/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config.dart';
import 'home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  User? user;
  late bool isSign;
  late bool isFirstTime;

  FirebaseAuth auth = FirebaseAuth.instance;

  User? get userProfile => auth.currentUser;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance
        .authStateChanges()
        .listen((event) => updateUserState(event));
    isSign = false;
    isFirstTime = false;
  }

  Future<dynamic> userFirstTime() async {
    final userFirstTime =
        FirebaseFirestore.instance.collection('users').doc(userProfile!.uid);
    await userFirstTime.get().then((value) => {
          isFirstTime = value['firstTime'],
          // FirebaseFirestore.instance
          //     .collection('users')
          //     .doc(userProfile!.uid)
          //     .update({"firstTime": true}),
        });
  }

  updateUserState(event) {
    setState(() {
      user = event;
      if (user == null) {
        isSign = false;
      } else {
        isSign = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);

    return FutureBuilder(
        future: userFirstTime(),
        builder: (context, AsyncSnapshot snapshot) {
          print("ROOT firstTime: $isFirstTime");
          print("ROOT isSign: $isSign");

          if (isSign == true && isFirstTime == true) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Navigation();
            }
          } else if (isSign == true && isFirstTime == false) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return welcomePage();
            }
          } else {
            return Scaffold(
              body: GetBuilder<AuthController>(
                builder: (_) {
                  print("ROOT is signed in: ${_.isSignedIn.value}");
                  return SafeArea(
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Config.screenWidth! * 0.0),
                        child: SignIn()),
                  );
                },
              ),
            );
          }
        });
  }
}
