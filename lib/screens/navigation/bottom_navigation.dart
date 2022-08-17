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

import 'package:livq/theme/text_style.dart';
import '../../widgets/common_widget.dart';

class BottomNavigation extends StatelessWidget {
  final Stream<QuerySnapshot> _videoCallStream =
      FirebaseFirestore.instance.collection('videoCall').snapshots();

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
            unselectedLabelStyle: AppTextStyle.unselectedLabelStyle,
            selectedLabelStyle: AppTextStyle.selectedLabelStyle,
            items: [
              _BottomNavigationBarItem(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _BottomStackNavigationBarItem(),
                    ],
                  ), '라이브 룸'),
              _BottomNavigationBarItem( Icon(Icons.person, size: 30.sp), 'Home'),
              _BottomNavigationBarItem( Icon(Icons.person, size: 30.w), '마이페이지'),
            ],
          ),
        )));
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationController landingPageController =
        Get.put(BottomNavigationController(), permanent: false);
    return Scaffold(
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
    );
  }

  BottomNavigationBarItem _BottomNavigationBarItem(var icon, String string){
    return BottomNavigationBarItem(
      icon: icon,
      label: string,
    );
  }

  Widget _BottomStackNavigationBarItem(){
    return  Stack(
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
                    sizedBoxWidget(20,0),
                    _clipRRectWidget(50, 18,18,textWidget('${snapshot.data!.docs.length}', TextStyle(color: Colors.white)) ),
                ],
              )
                  : Container();
            }),
      ],
    );
  }

  //많이 쓰이면 커멘위젯
  Widget _clipRRectWidget(int size, int width, int height, var text){
    return ClipRRect(
      borderRadius:
        BorderRadius.circular(50),
      child: Container(
        width: 18.w,
        height: 18.h,
        color: AppColors.primaryColor[900],
        child: Center(
          child: text),
        ),
      );
  }
}
