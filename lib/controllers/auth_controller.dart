import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../screens/home/home.dart';

class AuthController extends GetxController {
  var displayName = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  var googleAcc = Rx<GoogleSignInAccount?>(null);
  // var isSignedIn = false.obs;

  User? get userProfile => auth.currentUser;
  User? currentUser;
  RxBool isUser = false.obs;

  @override
  void onInit() {
    // print("AUTH: ${isSignedIn}");
    // displayName = userProfile != null ? userProfile!.displayName! : '';

    super.onInit();
  }

  void signInWithGoogle() async {
    try {
      googleAcc.value = await _googleSignIn.signIn();

      // auth로 user data 입력
      GoogleSignInAccount? googleLogin = await _googleSignIn.signIn();

      GoogleSignInAuthentication? googleAuth =
          await googleLogin?.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      //firestore에 user 저장
      User? user = (await auth.signInWithCredential(credential)).user;
      if (user != null) {
        final QuerySnapshot addUser = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: user.uid)
            .get();

        final List<DocumentSnapshot> userList = addUser.docs;

        if (userList.isEmpty) {
          FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'name': user.displayName,
            'email': user.email,
            'uid': user.uid,
            'timeRegister': DateTime.now().millisecondsSinceEpoch.toString(),
          });

          currentUser = user;
          update();
        } else {
          FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'timeRegister': DateTime.now().millisecondsSinceEpoch.toString(),
            // 'firstTime': true,
          });

          currentUser = user;
          isUser.value = true;
          update();
        }
      }
    } catch (e) {
      Get.snackbar('Error occurred!', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color(0xff0101ff),
          colorText: Colors.white);
    }
  }

  void signInWithApple() async {
    try {
      //로그인 동작 수행
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      final authResult =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      User? user = authResult.user;
      if (appleCredential.givenName != null) {
        user!.updateDisplayName(
            "${appleCredential.givenName} ${appleCredential.familyName}");
        displayName =
            "${appleCredential.givenName} ${appleCredential.familyName}";
      } else {
        user!.updateDisplayName("apple user");
        displayName = "apple user";
      }
      if (user != null) {
        final QuerySnapshot addUser = await FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: user.uid)
            .get();
        final List<DocumentSnapshot> userList = addUser.docs;
        if (userList.isEmpty) {
          FirebaseFirestore.instance.collection('users').doc(user.uid).set({
            'name': appleCredential.givenName != null
                ? "${appleCredential.givenName} ${appleCredential.familyName}"
                : "apple user",
            'email': user.email,
            'uid': user.uid,
          });
        } else {
          FirebaseFirestore.instance.collection('users').doc(user.uid).update({
            'timeRegister': DateTime.now().millisecondsSinceEpoch.toString(),
            // 'firstTime': true,
          });
        }
        currentUser = user;
        isUser.value = true;
        update();
      }
    } catch (e) {
      Get.snackbar('Error occurred!', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color(0xff0101ff),
          colorText: Colors.white);
    }
  }

  void signout() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userProfile!.uid)
          .get()
          .then((DocumentSnapshot documentsnapshot) {
        if (documentsnapshot.exists != null) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(userProfile!.uid)
              .update({
            'token': "signOut",
          });
        }
      });
      isUser.value = false;
      update();
      await auth.signOut();
      await _googleSignIn.signOut();

      update();
      Get.offAll(() => Home());
    } catch (e) {
      Get.snackbar('Error occurred!', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color(0xff0101ff),
          colorText: Colors.white);
    }
  }
}
