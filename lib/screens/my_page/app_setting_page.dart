import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/widgets/common_widget.dart';
import 'package:livq/widgets/listTile_widget.dart';

class appSettingPage extends StatefulWidget {
  @override
  State<appSettingPage> createState() => _appSettingPageState();
}

class _appSettingPageState extends State<appSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          color: AppColors.grey,
          icon: Icon(Icons.arrow_back),
          onPressed: () {Get.back();},
        ),
        title: Text("계정 / 정보 관리", style: TextStyle(color: Colors.black),),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              sizedBoxWidget(0, 10),
              Column(
                children: [
                  listTileWidget('알림 설정'),
                  dividerWidget(0),
                  listTileWidget('카테고리 설정'),
                  dividerWidget(0),
                  listTileWidget('차단, 신고하기'),
                  dividerWidget(0),
                  listTileWidget('기타'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
