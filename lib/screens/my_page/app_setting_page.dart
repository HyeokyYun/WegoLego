import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:livq/screens/my_page/sub_pages/logout_page.dart';
import 'package:livq/screens/my_page/sub_pages/notification_setting/notification_setting.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';

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
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "계정 / 정보 관리",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          // padding: EdgeInsets.fromLTRB(28, 0, 28, 0),
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Column(
                children: [
                  ListTile(
                    title: Text(
                      '알림 설정',
                      style: AppTextStyle.koBody2.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 18.sp,
                      color: Color(0xffADB5BD),
                    ),
                    onTap: () {
                      Get.to(() => NotificationSetting());
                    },
                  ),
                  Divider(
                    color: AppColors.grey[400],
                  ),
                  ListTile(
                    title: Text(
                      '카테고리 설정',
                      style: AppTextStyle.koBody2.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 18.sp,
                      color: Color(0xffADB5BD),
                    ),
                    onTap: () {
                      Get.to(() => appSettingPage());
                    },
                  ),
                  Divider(
                    color: AppColors.grey[400],
                  ),
                  ListTile(
                    title: Text(
                      '차단, 신고하기',
                      style: AppTextStyle.koBody2.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 18.sp,
                      color: Color(0xffADB5BD),
                    ),
                    onTap: () {
                      Get.to(() => appSettingPage());
                    },
                  ),
                  Divider(
                    color: AppColors.grey[400],
                  ),
                  ListTile(
                    title: Text(
                      '지인 추가',
                      style: AppTextStyle.koBody2.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 18.sp,
                      color: Color(0xffADB5BD),
                    ),
                    onTap: () {
                      Get.to(() => appSettingPage());
                    },
                  ),
                  Divider(
                    color: AppColors.grey[400],
                  ),
                  ListTile(
                    title: Text(
                      '기타',
                      style: AppTextStyle.koBody2.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 18.sp,
                      color: Color(0xffADB5BD),
                    ),
                    onTap: () {
                      Get.to(() => logoutPage());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
