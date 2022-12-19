import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livq/widgets/common_widget.dart';


class Question extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:  AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black), onPressed: () { Get.back(); },),
          title: textWidget('1:1 문의',TextStyle()),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textWidget("wegolego21@gmail.com으로 문의하세요" ,TextStyle())
            ],
          ),
        )
    );
  }
}
