import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:livq/theme/colors.dart';
import '/screens/home/agora/pages/call_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class ChannelList extends StatefulWidget {
  const ChannelList({Key? key}) : super(key: key);

  @override
  _ChannelListState createState() => _ChannelListState();
}

class _ChannelListState extends State<ChannelList> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  final List<IconData> _iconTypes = [
    Icons.directions_bus,
    FontAwesomeIcons.dog,
    FontAwesomeIcons.pencilAlt,
    FontAwesomeIcons.phone,
    Icons.sports_baseball,
    FontAwesomeIcons.question,
  ];

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('videoCall')
        .orderBy("timeRegister", descending: true)
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('다시 시도해주세요');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                title: _commonTextWidget("라이브 대기실"),
                elevation: 0.0,
                backgroundColor: Colors.white,
                centerTitle: true,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: _commonTextWidget("라이브 대기실"),
              elevation: 0.0,
              backgroundColor: Colors.white,
              centerTitle: true,
            ),
            body: Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                          child: _listViewWidget(snapshot,firebaseUser)
                      ),
                    ),
                  ],
                ),
              ),
            ),
            resizeToAvoidBottomInset: false,
          );
        });
  }
}


//위젯
Widget _sizedBoxWidget(int value) {
  return SizedBox(
    height: value.h,
  );
}

Widget _titleWidget(String text) {
  return Text(
    text,
    style: TextStyle(fontSize: 12, color: Colors.black54),
  );
}
Widget _subTitleWidget(String text) {
  return Text(
    text,
    style: TextStyle(fontSize: 12, color: Colors.grey),
  );
}
Widget _commonTextWidget(String text) {
  return Text(
    text,
    style: TextStyle(color: Colors.black),
  );
}

Widget _listViewWidget( AsyncSnapshot<QuerySnapshot> snapshot,var firebaseUser) {
  return ListView(
    padding: const EdgeInsets.all(20),
    children: snapshot.data!.docs
        .map((DocumentSnapshot document) {
      Map<String, dynamic> data =
      document.data()! as Map<String, dynamic>;
      return Card(
        shape: new RoundedRectangleBorder(
            borderRadius:
            new BorderRadius.circular(10.0)),
        elevation: 10.0,
        shadowColor: AppColors.grey[100],
        color: Color(0xffF1F3F5),
        child: Container(
          child: Padding(
            padding:
            const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Container(
              width: 340.w,
              child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  crossAxisAlignment:
                  CrossAxisAlignment.center,
                  children: [
                    _conWidget(data),
                    Container(
                      width: 80.w,
                      child: Column(
                        children: [
                          _sizedBoxWidget(50),
                          _connWidget(data, firebaseUser),
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        ),
      );
    }).toList(),
// children: _buildGridCards(context),
  );
}
Widget _conWidget(Map data) {
  return Container(
    width: 200.w,
    child: Row(
      children: [
        Container(
          width: 150.w,
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Text(
                data['name'] +
                    "님의 도움요청",
                style: TextStyle(
                    color: data['count'] ==
                        1
                        ? AppColors
                        .primaryColor[
                    900]
                        : AppColors
                        .grey[500],
                    fontSize: 11.sp),
              ),
              Container(
                  child: Text(
                    data['subcategory'],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.sp),
                  )),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _connWidget(Map data, var firebaseUser){
  return Container(
    width: 80.w,
    child: TextButton(
      child: Text(
        data['count'] == 1
            ? "답변 참여하기"
            : "도움 받는 중",
        //data['uid'],
        style: TextStyle(
            fontSize: 10.sp,
            color: Colors.white),
      ),
      onPressed: () {
        data['count'] == 1
            ? FirebaseFirestore
            .instance
            .collection(
            'videoCall')
            .doc(data['uid'])
            .get()
            .then((DocumentSnapshot
        documentSnapshot) {
          if (documentSnapshot
              .get(
              'count') ==
              1) {
            FirebaseFirestore
                .instance
                .collection(
                'videoCall')
                .doc(data[
            'uid'])
                .update({
              'count': 2,
              'helper':
              firebaseUser!
                  .uid,
            });
            //taker의 리스트에 저장
            FirebaseFirestore
                .instance
                .collection(
                'users')
                .doc(data[
            'uid'])
                .collection(
                'callHistory')
                .add({
              "isHelper":
              false,
              "name": firebaseUser!
                  .displayName,
              "uid":
              firebaseUser!
                  .uid,
              "question": data[
              'subcategory'],
              "timeRegister": DateTime
                  .now()
                  .millisecondsSinceEpoch
                  .toString(),
              "report":
              false,
            });
            //helper의 리스트에 저장
            FirebaseFirestore
                .instance
                .collection(
                'users')
                .doc(
              firebaseUser!
                  .uid,
            )
                .collection(
                'callHistory')
                .add({
              "isHelper":
              true,
              "name": data[
              'name'],
              "uid": data[
              'uid'],
              "question": data[
              'subcategory'],
              "timeRegister": DateTime
                  .now()
                  .millisecondsSinceEpoch
                  .toString(),
              "report":
              false,
            });
            Get.snackbar(
                '화면을 터치하여 도움을 주세요',
                "화면을 터치하면 원이 그려집니다.",
                snackPosition:
                SnackPosition
                    .TOP,
                backgroundColor:
                AppColors
                    .primaryColor,
                colorText:
                Colors
                    .white);
            Get.offAll(() =>
                CallPage_helper(
                  channelName:
                  data[
                  'uid'],
                ));
          }
        })
            : Get.snackbar(
            '이미 도움 받는 중입니다!',
            "감사합니",
            snackPosition:
            SnackPosition
                .TOP,
            backgroundColor:
            AppColors
                .primaryColor,
            colorText:
            Colors.white);
      },
      style: TextButton.styleFrom(
        backgroundColor:
        data['count'] == 1
            ? AppColors
            .primaryColor
            : AppColors
            .grey[500],
        shape: new RoundedRectangleBorder(
            borderRadius:
            new BorderRadius
                .circular(
                22.0)),
      ),
    ),
  );
}