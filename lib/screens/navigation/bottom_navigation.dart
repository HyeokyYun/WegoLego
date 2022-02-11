import 'dart:async';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livq/screens/home/buttons/animated_radial_menu.dart';
import 'package:livq/screens/home/home.dart';
import 'package:livq/screens/my_page/my_page.dart';
import 'package:livq/screens/channels/channel_list.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:livq/screens/navigation/bottom_navigation_controller.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/widgets/splash.dart';

class BottomNavigation extends StatelessWidget {
  final Stream<QuerySnapshot> _videoCallStream =
      FirebaseFirestore.instance.collection('videoCall').snapshots();

  final TextStyle unselectedLabelStyle = TextStyle(
      color: Colors.white.withOpacity(0.5),
      fontWeight: FontWeight.w500,
      fontSize: 12.sp);

  final TextStyle selectedLabelStyle = TextStyle(
      color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12.sp);

  BottomNavigation({Key? key}) : super(key: key);

  buildBottomNavigationMenu(context, landingPageController) {
    return Obx(() => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: SizedBox(
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            onTap: landingPageController.changeTabIndex,
            currentIndex: landingPageController.tabIndex.value,
            unselectedItemColor: Colors.grey[400],
            selectedItemColor: AppColors.primaryColor[800],
            unselectedLabelStyle: unselectedLabelStyle,
            selectedLabelStyle: selectedLabelStyle,
            items: [
              BottomNavigationBarItem(
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Icon(
                          Icons.chat,
                          size: 30.w,
                        ),
                        StreamBuilder<QuerySnapshot>(
                            stream: _videoCallStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Container(color: Color(0xffffffff));
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(color: Color(0xffffffff));
                              }
                              return snapshot.data!.docs.length > 0
                                  ? Row(
                                      children: [
                                        SizedBox(width: 20.w),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Container(
                                            width: 18.w,
                                            height: 18.h,
                                            color: AppColors.primaryColor[900],
                                            child: Center(
                                              child: Text(
                                                "${snapshot.data!.docs.length}",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container();
                            }),
                      ],
                    ),
                  ],
                ),
                label: '라이브 룸',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 30.sp,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 30.w,
                ),
                label: '마이페이지',
              ),
            ],
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationController landingPageController =
        Get.put(BottomNavigationController(), permanent: false);
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar:
          buildBottomNavigationMenu(context, landingPageController),
      body: Obx(() => IndexedStack(
            index: landingPageController.tabIndex.value,
            children: [
              ChannelList(),
              Home(),
              MyPage(),
            ],
          )),
    ));
  }
}
