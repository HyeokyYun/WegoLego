import 'package:livq/controllers/auth_controller.dart';
import 'package:livq/widgets/rounded_elevated_button.dart';
import 'package:livq/widgets/rounded_text_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config.dart';

class ResetForm extends StatelessWidget {
  const ResetForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _emailController = TextEditingController();

    final _authController = Get.find<AuthController>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          RoundedTextFormField(
            hintText: '이메일 ',
            controller: _emailController,
            validator: (value) {
              bool _isEmailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value!);
              if (!_isEmailValid) {
                return '유효하지 않은 이메일 양식입니다.';
              }
              return null;
            },
          ),
          SizedBox(height: Config.screenHeight! * 0.03),
          RoundedElevatedButton(
            title: 'Reset Password',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _authController.resetPassword(_emailController.text.trim());
              }
            },
            padding: EdgeInsets.symmetric(
                horizontal: Config.screenWidth! * 0.32,
                vertical: Config.screenHeight! * 0.02),
          ),
        ],
      ),
    );
  }
}
