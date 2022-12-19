import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:livq/screens/navigation/bottom_navigation.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';
import 'package:livq/widgets/common_widget.dart';
import 'package:livq/widgets/firebaseAuth.dart';

class CallHistory extends StatefulWidget {
  @override
  State<CallHistory> createState() => _CallHistoryState();
}

class _CallHistoryState extends State<CallHistory> {
  AuthClass _auth = AuthClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: textWidget('통화기록', TextStyle(color: Colors.black)),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          color: AppColors.grey,
          icon: Icon(Icons.arrow_back),
          onPressed: () {Get.back();},
        ),
      ),
      body: _showHistory(),
    );
  }

  Widget _showHistory() {
    Stream<QuerySnapshot<Map<String, dynamic>>> _callHistoryStream = _auth.CallHistoryStream();
    final TextEditingController _reportController = TextEditingController();
    return
      StreamBuilder<QuerySnapshot>(
          stream: _callHistoryStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                  ],
                ),
              );
            }else {
              return Container(
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
                              String docId = document.id;
                              return Card(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(10.0.w)),
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
                                            Container(
                                              width: 200.w,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 150.w,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            textWidget(data['isHelper']? "도와 받은 사람 : ": "도와준 사람 : ",AppTextStyle.koBody1),
                                                            textWidget(data['name'],AppTextStyle.koBody1,),
                                                          ],
                                                        ),
                                                       textWidget("질문 : " +data['question'],AppTextStyle.koBody2,)
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 80.w,
                                              child: Column(
                                                children: [
                                                  sizedBoxWidget(0, 50),
                                                  Container(
                                                    width: 60.w,
                                                    child: TextButton(
                                                      child: textWidget(data['report'] ? "신고함" : "신고하기", AppTextStyle.koButton.copyWith(color: AppColors.grey[50],),),
                                                      style: TextButton.styleFrom(
                                                        backgroundColor: data['report'] ? AppColors.grey[500] : Colors.red,
                                                        shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(22.0)),),
                                                      onPressed: () {
                                                        data['report'] ? Get.snackbar("이미 신고되었습니다.", "유저의 일정이상 신고가 반복되면 신고된 유저는 차단됩니다.",
                                                          snackPosition: SnackPosition.BOTTOM,
                                                          backgroundColor: AppColors.primaryColor,
                                                          colorText:Colors.white,
                                                        ) : showDialog(
                                                            context: context,
                                                            barrierDismissible: true,
                                                            builder: (BuildContextcontext) {
                                                              return AlertDialog(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.circular(10.0)),
                                                                backgroundColor: AppColors.grey[800],
                                                                title: Column(
                                                                  children: <Widget>[
                                                                    textWidget("신고 하고 싶은 내용을 적어주세요",
                                                                     AppTextStyle.koBody1.copyWith(color: Colors.white,)),
                                                                  ],
                                                                ),

                                                                content: Container(height: 100.h, width: 300.w, padding: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 10.h), decoration:
                                                                  BoxDecoration(color: Color(0xffC4C4C4), borderRadius: BorderRadius.circular(22),),
                                                                  child: TextFormField(
                                                                    controller:_reportController,
                                                                    keyboardType: TextInputType.multiline,
                                                                    maxLines: null,
                                                                    autofocus: false,
                                                                    decoration:
                                                                    InputDecoration(
                                                                      hintStyle: AppTextStyle.koBody2,
                                                                      fillColor: Colors.black,
                                                                      focusedBorder: InputBorder.none,
                                                                      enabledBorder: InputBorder.none,
                                                                      errorBorder: InputBorder.none,
                                                                      focusedErrorBorder: InputBorder.none,
                                                                    ),
                                                                    // validator: validator,
                                                                  ),
                                                                ),
                                                                actions: <Widget>[
                                                                  Center(
                                                                    child: Column(
                                                                      children: [
                                                                        ElevatedButton(
                                                                          onPressed:
                                                                              () async {
                                                                            FirebaseFirestore.instance.collection('users').doc(_auth.uid).collection("callHistory").doc(docId).update({"report": true,});
                                                                            //모니터링에 신고 내용 작성
                                                                            //새로운 collection에 랜덤으로 생성
                                                                            FirebaseFirestore.instance
                                                                                .collection("report")
                                                                                .add({
                                                                              "timeRegister": DateTime.now().millisecondsSinceEpoch.toString(),
                                                                              "reportContent": _reportController.text,
                                                                              "reportedUserName": data["name"],
                                                                              "reportedUserUid": data["uid"],
                                                                            });

                                                                            Get.offAll(BottomNavigation());
                                                                            Get.snackbar("신고되었습니다.", "유저의 일정이상 신고가 반복되면 신고된 유저는 차단됩니다.",
                                                                              snackPosition: SnackPosition.BOTTOM,
                                                                              backgroundColor: AppColors.primaryColor,
                                                                              colorText: Colors.white,
                                                                            );
                                                                          },
                                                                          child: textWidget("신고하기",AppTextStyle.koBody2.copyWith (color: AppColors.grey),),
                                                                          style: ElevatedButton.styleFrom(primary: Colors.white, fixedSize: Size(120.w, 43.h), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),),
                                                                        ),
                                                                        sizedBoxWidget(0, 15)
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                      },
                                                    ),
                                                  ),
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          } );
  }
}
