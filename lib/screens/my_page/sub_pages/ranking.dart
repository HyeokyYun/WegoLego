import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';

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
          padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "도움으로 세상을 밝혀준 랭킹",
                    style: AppTextStyle.koBody2.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 74.w,
                  ),
                  DropdownButton(
                    value: dropdownvalue,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.grey[700],
                    ),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: AppTextStyle.koBody2.copyWith(
                            color: AppColors.grey[700],
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                        dropdown = !dropdown;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
              Container(
                width: 340.w,
                height: 600.h,
                decoration: BoxDecoration(
                  color: AppColors.grey[50],
                  borderRadius: BorderRadius.circular(22.w),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey.withOpacity(0.1),
                      // spreadRadius: 5,
                      blurRadius: 20,
                      offset: Offset(0, 5), // changes position of shadow
                    ),
                  ],
                ),
                child: (dropdown)
                    ? StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .orderBy('help', descending: true)
                            .limit(10)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          final documents = snapshot.data!.docs;
                          return Container(
                            height: 200.h,
                            child: Column(
                              children: [
                                Expanded(
                                    child: ListView(
                                        children: documents
                                            .map((doc) => _buildItemWidget(doc))
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
                            return Center(child: CircularProgressIndicator());
                          }
                          return Container(
                            height: 200.h,
                            child: Column(
                              children: [
                                Expanded(
                                    child: ListView(
                                        children: documents
                                            .map((doc) => _buildItemWidget(doc))
                                            .toList())),
                              ],
                            ),
                          );
                        }),
              ),
              SizedBox(
                height: 44.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildItemWidget(DocumentSnapshot doc) {
  final rank = Rank(doc['help'], doc['ask'], doc['name']);

  //var num = ['1','2','3','4','5','6','7','8','9','10'];
  return ListTile(
      title: Container(
    color: AppColors.grey[50],
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 200.w,
                child: Row(children: [
                  //Text("$num[index]"),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(57),
                    child: SvgPicture.asset(
                      "assets/liveQ_logo.svg",
                      height: 30.h,
                      width: 30.w,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    rank.name,
                    style: TextStyle(fontSize: 20),
                  ),
                ]),
              ),
              Container(
                  height: 15,
                  child: Row(
                    children: [
                      SizedBox(
                          width: 65.w,
                          child: Row(children: [
                            SvgPicture.asset("assets/my_page/heartIcon.svg"),
                            Text(
                              "${rank.ask}",
                              style: TextStyle(fontSize: 16),
                            ),
                          ])),
                      Image.asset("assets/my_page/yellow_i.png"),
                      SizedBox(width: 7.w),
                      Text(
                        "${rank.help}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  )),
            ]),
        Divider(
          color: AppColors.grey[400],
          // thickness: 1.0,
        ),
      ],
    ),
  ));
}

class Rank {
  int help;
  int ask;
  String name;

  Rank(this.help, this.ask, this.name);
}
