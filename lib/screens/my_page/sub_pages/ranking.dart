import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';
import 'package:livq/widgets/common_widget.dart';

class Ranking_Page extends StatefulWidget {
  const Ranking_Page({Key? key}) : super(key: key);

  @override
  State<Ranking_Page> createState() => _Ranking_PageState();
}

class _Ranking_PageState extends State<Ranking_Page> {
  String dropdownvalue = '가장 많이';
  bool dropdown = true;
  var items = [
    '가장 많이',
    '가장 만족',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        title: SvgPicture.asset(
          "assets/app_bar/appBar.svg",
          height: 27.h,
          width: 86.w,
        ),
        centerTitle: false,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        //scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 0),
          child: Column(
            children: [
              Row(
                children: [
                  textWidget(
                    "도움으로 세상을 밝혀준 랭킹",AppTextStyle.koBody2.copyWith(color: AppColors.grey)),
                 sizedBoxWidget(74, 0)
                ],
              ),
              sizedBoxWidget(0, 16),
              Container(
                width: 340.w,
                height: 600.h,
                child:
                    dropdown
                        ? StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .orderBy('help', descending: true)
                                .limit(10)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              final documents = snapshot.data!.docs;
                              return Container(
                                height: 200.h,
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: ListView(
                                            children: documents
                                                .map((doc) =>
                                                    _buildItemWidget(doc))
                                                .toList())),
                                  ],
                                ),
                              );
                            })
                        : StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .orderBy('ask', descending: true)
                                .limit(10)
                                .snapshots(),
                            builder: (context, snapshot) {
                              final documents = snapshot.data!.docs;
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              return Container(
                                height: 200.h,
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: ListView(
                                            children: documents
                                                .map((doc) =>
                                                    _buildItemWidget(doc))
                                                .toList())),
                                  ],
                                ),
                              );
                            }),
              ),
             sizedBoxWidget(0, 44)
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildItemWidget(DocumentSnapshot doc) {
  final rank = Rank(doc['help'], doc['ask'], doc['name'], doc['photoURL']);

  return ListTile(
      title: Container(
    height: 60.h,
    width: 325.w,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
      color: Color(0xffFFF9EA),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 200.w,
              height:34.h ,
              child: Row(children: [
                sizedBoxWidget(10, 0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(57),
                  child: Image.network(
                    rank.photo,
                    height: 30.h,
                    width: 30.w,
                    fit: BoxFit.fill,
                  ),
                ),
                sizedBoxWidget(10, 0),
                Container(
                  width: 140.w,
                  child: Text(
                    rank.name,
                    style: AppTextStyle.koBody2.copyWith(fontSize: 14.sp,height: 1.2.h),
                  ),
                ),
              ]),
            ),
            Container(
                height: 15.h,
                child: Row(
                  children: [
                    SizedBox(
                        width: 55.w,
                        child: Row(children: [
                          SvgPicture.asset("assets/my_page/heartIcon.svg",),
                          textWidget("${rank.ask}", TextStyle(fontSize: 14),
                          ),
                        ])),
                    Image.asset("assets/my_page/yellow_i.png"),
                    sizedBoxWidget(8, 0),
                    textWidget("${rank.help}", TextStyle(fontSize: 14)),
                    sizedBoxWidget(5, 0),
                  ],
                )),
          ]),
        ],
      ),
    ),
  ));
}

class Rank {
  int help;
  int ask;
  String name;
  String photo;

  Rank(this.help, this.ask, this.name, this.photo);
}
