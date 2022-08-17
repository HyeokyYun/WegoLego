import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:livq/screens/my_page/app_setting_page.dart';
import 'package:livq/screens/my_page/my_setting_page.dart';
import 'package:livq/screens/my_page/sub_pages/1:1_question.dart';
import 'package:livq/screens/my_page/sub_pages/call_history.dart';
import 'package:livq/screens/my_page/sub_pages/friends_add.dart';
import 'package:livq/screens/my_page/sub_pages/guide_page.dart';
import 'package:livq/screens/my_page/sub_pages/instruction_manual.dart';
import 'package:livq/screens/my_page/sub_pages/logout_page.dart';
import 'package:livq/screens/my_page/sub_pages/notification_setting/notification_setting.dart';
import 'package:livq/screens/my_page/sub_pages/ranking.dart';
import 'package:livq/screens/my_page/sub_pages/review.dart';
import 'package:livq/screens/my_page/sub_pages/thanks_letters.dart';
import 'package:livq/theme/text_style.dart';
import 'package:livq/widgets/common_widget.dart';
import 'package:livq/widgets/firebaseAuth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/my_page/sub_pages/friends_edit.dart';
import '../theme/colors.dart';

Widget listTileWidget(String title) {
  AuthClass _auth = AuthClass();
  Stream<DocumentSnapshot> _userStream = _auth.UserStream();
  final RatingService _ratingService = RatingService();
  if (title == '회원정보 수정') {
    return StreamBuilder<DocumentSnapshot>(
      stream: _userStream,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        final getdata = snapshot.data;
        if (snapshot.hasData) {
          return ListTile(
            title: textWidget(
              title,
              AppTextStyle.koBody2.copyWith(
                color: AppColors.grey,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 18.sp,
              color: AppColors.grey[500],
            ),
            onTap: () {
              Get.to(mySettingPage(
                getName: getdata?['name'],
                getEmail: getdata?['email'],
              ));
            },
          );
        }
        return ListTile(
          title: textWidget(
            '회원정보 수정',
            AppTextStyle.koBody2.copyWith(
              color: AppColors.grey,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 18.sp,
            color: AppColors.grey[500],
          ),
          onTap: () {},
        );
      },
    );
  } else {
    return ListTile(
      title: textWidget(
        title,
        AppTextStyle.koBody2.copyWith(
          color: AppColors.grey,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 18.sp,
        color: AppColors.grey[500],
      ),
      onTap: () async {
        if (title == '친구 추가하기') {
          Get.to(FriendAddPage());
        } else if (title == '친구 관리하기') {
          Get.to(
            FriendEditPage(),
            transition: Transition.rightToLeft,
          );
        } else if (title == '통화기록') {
          Get.to(
            CallHistory(),
            transition: Transition.rightToLeft,
          );
        } else if (title == '받은 감사편지') {
          Get.to(const ThankyouLetters());
        } else if (title == '랭킹') {
          Get.to(() => const Ranking_Page());
        } else if (title == '공지사항') {
          Get.snackbar("공지사항 준비중입니다.", "원활한 소통을 위해 준비중입니다.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.primaryColor,
              colorText: Colors.white);
        } else if (title == '1:1 문의') {
          Get.to(() => Question());
        } else if (title == '사용설명서') {
          Get.to(() => const guidePage());
        } else if (title == '리뷰 쓰러가기') {
          Timer(const Duration(seconds: 2), () {
            _ratingService.isSecondTimeOpen().then((secondOpen) {
              if (!secondOpen) {
                _ratingService.showRating();
              }
            });
          });
        } else if (title == '라이큐 공유') {
          Get.to(() => Instruction());
        } else if (title == '앱 설정') {
          Get.to(() => appSettingPage());
        } else if (title == '개인정보 처리방침') {
          if (!await launch("https://wegolego.tistory.com/1"))
            throw 'Could not launch the website';
        } else if (title == '이용 약관') {
          if (!await launch("https://wegolego.tistory.com/2"))
            throw 'Could not launch the website';
        } else if (title == '알림 설정') {
          Get.to(() => NotificationSetting());
        } else if (title == '카테고리 설정') {
          Get.snackbar("카테고리 준비중입니다.", "더 나은 질문과 해결을 위해 준비중입니다.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: AppColors.primaryColor,
              colorText: Colors.white);
        } else if (title == '차단, 신고하기') {
          Get.to(() => CallHistory());
        } else if (title == '기타') {
          Get.to(() => logoutPage());
        }
      },
    );
  }
}
