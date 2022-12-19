import 'package:livq/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config.dart';
import 'localWidgets/reset_form.dart';
import 'package:livq/widgets/common_widget.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Config.screenWidth! * 0.04),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ),
            textWidget('비밀번호 찾기',  AppTextStyle.koHeadline1),
            textWidget('비밀번호 재설정을 위한 이메일을 입력하세요.',  AppTextStyle.koBody1),
            sizedBoxWidget( 0, 30 ),
            sizedBoxWidget( 0, 10 ),
            // SizedBox(height: Config.screenHeight! * 0.1),
            // SizedBox(height: Config.screenHeight! * 0.03),
            const ResetForm(),
            sizedBoxWidget( 0, 90)
            //SizedBox(height: Config.screenHeight! * 0.3),
          ],
        ),
      )),
    );
  }
}
