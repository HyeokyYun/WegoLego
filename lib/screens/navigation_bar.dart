import 'dart:async';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:circular_reveal_animation/circular_reveal_animation.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livq/screens/home/buttons/animated_radial_menu.dart';
import 'package:livq/screens/home/home.dart';
import 'package:livq/screens/my_page/my_page.dart';
import 'package:livq/screens/channels/channel_list.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/widgets/splash.dart';

class Navigation extends StatefulWidget {
  Navigation({Key? key}) : super(key: key);

  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation>
    with SingleTickerProviderStateMixin {
  // final autoSizeGroup = AutoSizeGroup();
  int _bottomNavIndex = 1; //default index of a first screen
  late var color =  Colors.grey[400] ;
  late var color2 =  Colors.grey[400] ;

  final List<Widget> widgetList = <Widget>[
    // ChannelList(),
    // ChannelList(),
    ChannelList(),
    Home(),
    MyPage(),
  ];

  void _onTap(int index) {
    setState(() {
      _bottomNavIndex = index;
      if(index == 0){
        color = Colors.grey[700];
        color2 = Colors.grey[400];
      }else if(index == 1){
        color= Colors.grey[400];
        color2 = Colors.grey[400];
      }
      else if(index ==2){
        color2 = Colors.grey[700];
        color = Colors.grey[400];
      }

    });
  }






  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _videoCallStream =
    FirebaseFirestore.instance.collection('videoCall').snapshots();

    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
          extendBody: true,
          //항목들
          body: widgetList[_bottomNavIndex],

          //navigation bar
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap:_onTap,
              currentIndex: _bottomNavIndex,
              selectedItemColor:Colors.grey[700],
              unselectedItemColor: Colors.grey[400],
              items: [
                BottomNavigationBarItem(
                  icon:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Stack(
                        children: [
                          SvgPicture.asset(
                            "assets/app_bar/bottomIcon1.svg",
                            //      "assets/app_bar/bottomIcon2.svg",
                            color: color,
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
                  title: Text('라이브 룸'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home,size: 30.sp,),
                  title: Text('홈'),
                ),
                BottomNavigationBarItem(
                  icon:
                  SvgPicture.asset(
                      "assets/app_bar/bottomIcon2.svg",
                      color: color2
                  ),
                  title: Text('마이 페이지'),
                )
              ])),
    );
  }
}
