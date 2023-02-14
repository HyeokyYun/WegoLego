// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livq/Constants.dart';
import 'package:livq/controllers/noti_controller.dart';
// import 'package:livq/screens/chennels/chennel_list.dart';
import 'package:livq/screens/home/agora/pages/thank_you.dart';
import 'package:livq/screens/home/home.dart';
import 'package:livq/screens/root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/widgets/splash.dart';
import 'package:yaml/yaml.dart';
// import 'package:get/get_navigation/get_navigation.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'controllerBindings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

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
  final NotiController c = Get.put(NotiController());

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance.collection("videoCall");
    return ScreenUtilInit(
        designSize: Size(376, 812),
        builder: (_, child) => GetMaterialApp(
              initialBinding: ControllerBindings(),
              debugShowCheckedModeBanner: false,
              home: AnimatedSplashScreen(
                duration: 2000,
                splash: splashWidget(),
                splashIconSize: 360.0,
                backgroundColor: Color(0xffFFFDE7),
                nextScreen: FutureBuilder(
                    future: c.initialize(),
                    builder: (context, AsyncSnapshot snapshot) {
                      return Root();
                      // return BottomNavigation();
                    }),
              ),
            ));
  }
}
