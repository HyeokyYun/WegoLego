import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livq/screens/my_page/my_page.dart';
import 'package:livq/theme/colors.dart';

class callHistory extends StatefulWidget {
  @override
  State<callHistory> createState() => _callHistoryState();
}

class _callHistoryState extends State<callHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          color: AppColors.grey,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
            // Get.off(
            //   Navigation(),
            //   transition: Transition.leftToRightWithFade,
            // );
          },
        ),
        title: Text(
          "통화 기록",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(28, 0, 28, 0),
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [],
          ),
        ),
      ),
    );
  }
}
