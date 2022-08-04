import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livq/widgets/common_widget.dart';

class StateChange extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            '활동상태 설정',
            //   style: appbartitlestyle(),
          ),
          backgroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.width / 2,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(
                      "https://drive.google.com/uc?export=view&id=1YZyTxIshyloO3YvQhMH5g4fSiIXOfM4m",
                    ),
                  ),
                ),
              ),
              sizedBoxWidget(0, 10),
              textWidget("준비중입니다!! 다음 버전에서 만나뵙겠습니다!", TextStyle())
            ],
          ),
        ));
  }
}
