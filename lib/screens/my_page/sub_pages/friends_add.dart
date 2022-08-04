import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:livq/models/User.dart';
import 'package:livq/screens/home/buttons/animated_radial_menu.dart';
import 'package:livq/widgets/SearchScaffold.dart';
import 'package:livq/widgets/common_widget.dart';
import 'package:livq/widgets/firebaseAuth.dart';


class FriendAddPage extends StatefulWidget {
  @override
  _FriendState createState() => _FriendState();
}

class _FriendState extends State<FriendAddPage> {

  AuthClass _auth = AuthClass();
  final _channelController = TextEditingController();
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
                              sizedBoxWidget(5, 0),
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
                                .doc(_auth.uid)
                                .update({
                              "frienduid":
                              FieldValue.arrayUnion([data.uid]),
                            });

                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(data.uid)
                                .update({
                              "frienduid":
                              FieldValue.arrayUnion([_auth.uid]),
                            });
                          },
                            child: textWidget( "추가하기", TextStyle(fontSize: 11.sp, color: Colors.white)),
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