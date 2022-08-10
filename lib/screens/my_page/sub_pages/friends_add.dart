/*
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:livq/controllers/auth_controller.dart';
import 'package:livq/push_notification/push_notification.dart';
import 'package:livq/screens/home/agora/pages/call_taker.dart';
import 'package:livq/screens/home/buttons/animated_radial_menu.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firestore_search/firestore_search.dart';

class Friend extends StatefulWidget {
  @override
  _FriendState createState() => _FriendState();
}

class _FriendState extends State<Friend> {
  FirebaseAuth auth = FirebaseAuth.instance;

  User? get userProfile => auth.currentUser;
  User? currentUser;

  var firebaseUser = FirebaseAuth.instance.currentUser;
  final _channelController = TextEditingController();

  final TextEditingController _categoryController = TextEditingController();
  late int askCount;

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ButtonController());

    return FirestoreSearchScaffold(
      firestoreCollectionName: 'users',
      searchBy: 'name',
      scaffoldBody: Center(),
      dataListFromSnapshot: DataModel().dataListFromSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<DataModel>? dataList = snapshot.data;
          if (dataList!.isEmpty) {
            return const Center(
              child: Text('No  Returned'),
            );
          }
          return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final DataModel data = dataList[index];

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                      borderRadius: BorderRadius.circular(57),
                      child: Image.network(
                        '${data.photo}',
                        height: 30.h,
                        width: 30.w,
                        fit: BoxFit.fill,
                      ),
                    ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${data.name}',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline6,
                      ),
                    ),
                    ElevatedButton(onPressed: () {
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(firebaseUser!.uid)
                          .update({
                        "frienduid":
                        FieldValue.arrayUnion([data.uid]),
                      });

                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(data.uid)
                          .update({
                        "frienduid":
                        FieldValue.arrayUnion([firebaseUser!.uid]),
                      });
                    },
                        child: Text("친구 추가")),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       bottom: 8.0, left: 8.0, right: 8.0),
                    //   child: Text('${data.developer}',
                    //       style: Theme.of(context).textTheme.bodyText1),
                    // )
                  ],
                );
              });
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No Results Returned'),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: SvgPicture.asset(
    //       "",
    //     ),
    //     elevation: 0.0,
    //     centerTitle: false,
    //     backgroundColor: Color(0xffF8F9FA),
    //   ),
    //   body: Container(
    //     color: Color(0xffF8F9FA),
    //     child: Stack(children: [
    //
    //       SingleChildScrollView(
    //         child: Center(
    //           child: Column(
    //             children: [
    //
    //               Container(
    //                 width: 350.w,
    //                 height: 500.h,
    //                 child: Padding(
    //                   padding: EdgeInsets.all(8.0),
    //                   child: _friendsWidget(),
    //                 ),
    //                 decoration: BoxDecoration(
    //                   color: Colors.white,
    //                   borderRadius: BorderRadius.circular(8),
    //                   boxShadow: [
    //                     BoxShadow(
    //                       color: Colors.grey.withOpacity(0.1),
    //                       spreadRadius: 5,
    //                       blurRadius: 7,
    //                       offset: Offset(0, 3), // changes position of shadow
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               SizedBox(height: 30.h),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ]),
    //   ),
    // );

  }
}
class DataModel{
  final String? name;
  final String? photo;
  final String? uid;

  DataModel({this.name,this.photo,this.uid});

  List<DataModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
        snapshot.data() as Map<String, dynamic>;

      return DataModel(
          name: dataMap['name'],
          photo: dataMap['photoURL'],
          uid : dataMap['uid']);
      }).toList();
    }
  }

 */

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:livq/controllers/auth_controller.dart';
import 'package:livq/models/User.dart';
import 'package:livq/push_notification/push_notification.dart';
import 'package:livq/screens/home/buttons/animated_radial_menu.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';
import 'package:livq/widgets/SearchScaffold.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firestore_search/firestore_search.dart';

class FriendAddPage extends StatefulWidget {
  @override
  _FriendState createState() => _FriendState();
}

class _FriendState extends State<FriendAddPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  User? get userProfile => auth.currentUser;
  User? currentUser;

  var firebaseUser = FirebaseAuth.instance.currentUser;
  final _channelController = TextEditingController();

  final TextEditingController _categoryController = TextEditingController();
  late int askCount;


  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    Get.put(ButtonController());

    return SearchScaffold(
      firestoreCollectionName: 'users',
      searchBy: 'name',
      scaffoldBody: Center(),
      dataListFromSnapshot: UserModel().dataListFromSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<UserModel>? dataList = snapshot.data;
          if (dataList!.isEmpty) {
            return const Center(
              child: Text('No a Returned'),
            );
          }
          return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final UserModel data = dataList[index];

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(57),
                                child: Image.network(
                                  '${data.photoURL}',
                                  height: 40.h,
                                  width: 34.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                '${data.name}',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold
                                ),

                              ),
                            ],
                          ),

                          ElevatedButton(onPressed: (){
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(firebaseUser!.uid)
                                .update({
                              "frienduid":
                              FieldValue.arrayUnion([data.uid]),
                            });

                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(data.uid)
                                .update({
                              "frienduid":
                              FieldValue.arrayUnion([firebaseUser!.uid]),
                            });
                          },
                            child: Text(
                              "추가하기",
                              style: TextStyle(fontSize: 11.sp, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              //  padding: EdgeInsets.all(10.sp),
                              elevation: 0,
                              primary: Color(0xffFFA300),
                              fixedSize: Size(73.w, 27.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),)
                        ],
                      ),
                    ),
                  ],
                );
              });
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No Resultsssss Returned'),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
