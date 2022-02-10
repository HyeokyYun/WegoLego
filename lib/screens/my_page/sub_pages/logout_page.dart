import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:livq/controllers/auth_controller.dart';
import 'package:livq/theme/colors.dart';

class logoutPage extends StatefulWidget {
  @override
  State<logoutPage> createState() => _logoutPageState();
}

class _logoutPageState extends State<logoutPage> {
  @override
  Widget build(BuildContext context) {
    final _authController = Get.find<AuthController>();

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

        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
        //  padding: EdgeInsets.fromLTRB(28, 0, 28, 0),
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
                      "로그아웃",
                      style: TextStyle(fontSize: 14, color: Color(0xFF495057)),
                    ),
                    trailing: Container(
                      height: 24,
                      width: 24,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFFADB5BD),
                      ),
                    ),
                    onTap: () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text("로그아웃 하시겠습니까?"),
                          content:
                          const Text("로그아웃시 회원님의 정보는 유지되고 다시 로그인이 필요합니다."),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  _authController.signout();
                                },
                                child: const Text("YES")),
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text("NO"))
                          ],
                        ),
                      );
                    },
                  ),
                  Divider(
                    color: AppColors.grey[400],
                  ),
                  ListTile(
                    title: Text(
                      "탈퇴",
                      style: TextStyle(fontSize: 14, color: Color(0xFF495057)),
                    ),
                    trailing: Container(
                      height: 24,
                      width: 24,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFFADB5BD),
                      ),
                    ),
                    onTap: () {
                      Get.defaultDialog(
                        title: "sana_livq를 탈퇴하시겠습니까?",
                        middleText: "탈퇴 시 회원님의 정보가 삭제됩니다.",
                        actions: [
                          TextButton(
                              onPressed: () {
                                _authController.deleteUser();
                              },
                              child: const Text("YES")),
                          TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text("NO"))
                        ],
                      );
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
