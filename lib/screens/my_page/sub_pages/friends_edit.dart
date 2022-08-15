
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:livq/widgets/common_widget.dart';

import '../../../models/User.dart';
import '../../../theme/colors.dart';
import '../../../widgets/firebaseAuth.dart';



class FriendEditPage extends StatefulWidget {
  @override
  _FriendEditState createState() => _FriendEditState();
}

class _FriendEditState extends State<FriendEditPage> {

  AuthClass _auth = AuthClass();
  FirebaseAuth auth = FirebaseAuth.instance;
  User? get userProfile => auth.currentUser;
  User? currentUser;

  var firebaseUser = FirebaseAuth.instance.currentUser;
  final _channelController = TextEditingController();
  late int askCount;


  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text(
            "친구 관리",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
        child: Column(
          children:[
            sizedBoxWithChild(329, 336, _friendsEditWidget()),
          ]
        )
        )
    );
  }

  Widget _friendsEditWidget() {
    return FutureBuilder(
        future:
        FirebaseFirestore.instance.collection('users').doc(_auth.uid).get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            var data = snapshot.data.data();

            //final UserModel data = dataList[index];

            var friend = data['frienduid'];
            return ListView.builder(
                itemExtent: 80,
                //itemCount: snapshot.data.docs.length,
                itemCount: friend.length,
                itemBuilder: (context, index) {
                  //final UserModel data2 = dataList![index];
                  return Column(
                    children: [
                      ListTile(
                        //Icon(Icons.person,color: Colors.black54,),
                        title: Row(
                          children: [
                            friendPhotoWidget(friend[index].toString()),
                            sizedBoxWidget(5, 0),
                            friendNameWidget(friend[index].toString()),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                              showAlertDialog(context);
                  //삭제 기능 추가
                  //
                  //           FirebaseFirestore.instance
                  //               .collection("users")
                  //               .doc(firebaseUser!.uid)
                  //               .update({
                  //             "frienduid":
                  //             FieldValue.arrayRemove([data.uid]),
                  //           });
                  //
                  //           FirebaseFirestore.instance
                  //               .collection("users")
                  //               .doc(data.uid)
                  //               .update({
                  //             "frienduid":
                  //             FieldValue.arrayRemove([firebaseUser!.uid]),
                  //           });

                          },

                          child:textWidget(
                              "삭제하기", TextStyle(fontSize: 20.sp, color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            //  padding: EdgeInsets.all(10.sp),
                            elevation: 0,
                            primary: Colors.grey,
                            fixedSize: Size(80.w, 27.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                });
          } else {
            return Container();
          }
        });
  }


  Widget friendNameWidget(String uid) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.data()['name']);
          }
          return Text(" ");
        });
  }

  Widget friendPhotoWidget(String uid) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(57),
              child: Image.network(
                "${snapshot.data!.data()['photoURL']}",
                height: 37.h,
                width: 33.w,
                fit: BoxFit.fill,
              ),
            );
          }
          return Text(" ");
        });
  }}

showAlertDialog(BuildContext context) {

  // Widget okButton = TextButton(
  //   child: Text("OK"),
  //   onPressed: () { Navigator.pop(context)},
  // );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("친구 추가"),
    content: Text("친구 삭제 완료"),
    // actions: [
    //   okButton,
    // ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}