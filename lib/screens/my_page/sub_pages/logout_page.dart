import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livq/controllers/auth_controller.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/widgets/common_widget.dart';

class logoutPage extends StatefulWidget {
  @override
  State<logoutPage> createState() => _logoutPageState();
}

class _logoutPageState extends State<logoutPage> {
  @override
  Widget build(BuildContext context) {
    final _authController = Get.find<AuthController>();
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(color: AppColors.grey,
          icon: Icon(Icons.arrow_back), onPressed: () {Get.back();},),
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
                  ListTile(
                    title: textWidget("로그아웃", TextStyle(fontSize: 14, color: Color(0xFF495057)),),
                    trailing: Container(height: 24, width: 24,
                      child: Icon(Icons.arrow_forward_ios,color: Color(0xFFADB5BD),),
                    ),
                    onTap: () {
                      Get.dialog(
                        AlertDialog(
                          title: Text("로그아웃 하시겠습니까?"),
                          content: Text("로그아웃시 회원님의 정보는 유지되고 다시 로그인이 필요합니다."),
                          actions: [
                            TextButton(onPressed: () {_authController.signout();}, child: Text("YES")),
                            TextButton(onPressed: () {Get.back();}, child: Text("NO"))
                          ],
                        ),
                      );
                    },
                  ),
                  dividerWidget(0),
                  ListTile(
                    title: textWidget("탈퇴", TextStyle(fontSize: 14, color: Color(0xFF495057))),
                    trailing: Container(height: 24, width: 24,
                      child: Icon(Icons.arrow_forward_ios, color: Color(0xFFADB5BD),),
                    ),
                    onTap: () {
                      Get.defaultDialog(
                        title: "sana_livq를 탈퇴하시겠습니까?",
                        middleText: "탈퇴 시 회원님의 정보가 삭제됩니다.",
                        actions: [
                          TextButton(onPressed: () {_authController.deleteUser();}, child: const Text("YES")),
                          TextButton(onPressed: () {Get.back();}, child: const Text("NO"))
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
