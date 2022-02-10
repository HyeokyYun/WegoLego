import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:livq/theme/colors.dart';

import '/screens/home/agora/pages/call_helper.dart';
import 'package:livq/screens/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class ThankyouLetters extends StatefulWidget {
  const ThankyouLetters({Key? key}) : super(key: key);

  @override
  _ThankyouLettersState createState() => _ThankyouLettersState();
}

class _ThankyouLettersState extends State<ThankyouLetters> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .collection('thankLetter')
        .orderBy("timeRegister", descending: true)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "감사편지",
                  style: TextStyle(color: Colors.black),
                ),
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
              title: Text(
                "감사편지",
                style: TextStyle(color: Colors.black),
              ),
              elevation: 0.0,
              backgroundColor: Colors.white,
              centerTitle: true,
              leading: IconButton(
                color: AppColors.grey,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Get.back();
                },
              ),
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
                        child: ListView(
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
                                    // height:
                                    //Config.screenHeight! * 0.103,
                                    width: 350.w,
                                    //Config.screenWidth! * 0.322,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 210.w,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 150.w,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data['name'] + "님의 감사편지",
                                                      style: TextStyle(
                                                          fontSize: 11.sp),
                                                    ),
                                                    Container(
                                                        child: Text(
                                                      data['thankLetter'],
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.sp),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          // children: _buildGridCards(context),
                        ),
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
