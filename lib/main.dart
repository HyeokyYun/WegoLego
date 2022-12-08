import 'package:livq/Constants.dart';
import 'package:livq/screens/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'controllerBindings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> _backMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('background message ${message.notification}');
}

Future<void> main() async {
  Constants.setEnvironment(Environment.LOCAL);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_backMessage);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(376, 812),
        builder: () => GetMaterialApp(
              initialBinding: ControllerBindings(),
              debugShowCheckedModeBanner: false,
              home: Home(),
            ));
  }
}
