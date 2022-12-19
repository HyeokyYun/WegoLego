import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:livq/controllers/auth_controller.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';
import 'package:livq/widgets/common_widget.dart';
import 'package:livq/widgets/firebaseAuth.dart';
import 'package:livq/widgets/listTile_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class mySettingPage extends StatefulWidget {
  const mySettingPage({Key? key, required this.getName, required this.getEmail})
      : super(key: key);
  final String getName;
  final String getEmail;

  @override
  State<mySettingPage> createState() => _mySettingPageState();
}

class _mySettingPageState extends State<mySettingPage> {
  bool ifChangeName = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  late String userName;

  AuthClass _auth = AuthClass();
  PickedFile? _image;
  late String photoURL;
  String? downloadURL;

  @override
  void initState() {
    userName = widget.getName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = userName;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(color: AppColors.grey, icon: Icon(Icons.arrow_back), onPressed: () {Get.back();}),
        title: textWidget("계정 / 정보 관리",TextStyle(color: Colors.black)),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(28.w, 0, 28.w, 0),
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizedBoxWidget(0, 10),
                  textWidget('   계정 정보', AppTextStyle.koBody2.copyWith(color: AppColors.grey),),
                  _editProfile(),
                  dividerWidget(0),
                  listTileWidget('개인정보 처리방침'),
                  dividerWidget(0),
                  listTileWidget('이용 약관'),
                ],
              ),
        ),
      ),
    );
  }

  Widget _editProfile() {
    final _authController = Get.find<AuthController>();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Stack(
            children: [
              _image == null
                  ? sizedBoxWithChild(120, 120, UserFutureBuilder(data: 'photoURL',textStyle: TextStyle()))
                  : ClipRRect(borderRadius: BorderRadius.circular(57),
                      child: Image.file(File(_image!.path), height: 114.h, width: 114.w, fit: BoxFit.fill,),),
              Positioned(bottom: 1.h, right: 1.w, child: _editImage(),)
            ],
          ),
          ifChangeName
              ? ListTile(
                  title: textWidget('이름 변경', AppTextStyle.koBody2.copyWith(color: AppColors.grey,),),
                  subtitle: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: _nameController.clear,
                        icon: Icon(Icons.cancel, color: AppColors.grey[300],),),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.grey[300]!),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.grey[300]!),
                      ),
                    ),
                    validator: (String? value) {
                      if (value!.isEmpty)
                        return 'Please enter some text';
                      else if (value.length <= 2) {
                        return '2자리 이상 입력해주세요. ';
                      } else if (value.length >= 7) {
                        return '6글자 이하로 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  trailing: IconButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(_auth.uid)
                            .update({'name': _nameController.text});
                        setState(() {
                          setState(() {
                            _authController.displayName = _nameController.text;
                            _auth.firebaseUser
                                ?.updateDisplayName(_nameController.text);
                            userName = _nameController.text;
                            ifChangeName = false;
                          });
                        });
                      }
                    },
                    icon: Icon(Icons.check, color: AppColors.grey[500],),
                  ))
              : ListTile(
                  title: textWidget('이름', AppTextStyle.koBody2.copyWith(color: AppColors.grey,),),
                  subtitle: textWidget(userName,TextStyle()),
                  trailing: TextButton( onPressed: () {setState(() {ifChangeName = true;});},
                    child: textWidget("변경",AppTextStyle.koBody2.copyWith(color: Color(0xffFF5B5B))),),
                ),
          ListTile(
            title: textWidget('이메일', AppTextStyle.koBody2.copyWith(color: AppColors.grey)),
            subtitle: textWidget(widget.getEmail,TextStyle()),
          ),
        ],
      ),
    );
  }


  Future _getImageFromCam() async {
    String? uploadURL;
    PickedFile? image =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
    await firebase_storage.FirebaseStorage.instance
        .ref("profile/${_auth.uid}")
        .putFile(File(_image!.path));
    downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref("profile/${_auth.uid}")
        .getDownloadURL();
    uploadURL = downloadURL;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.uid)
        .update({'photoURL': uploadURL});
  }

  Future _getImageFromGallery() async {
    String? uploadURL;
    PickedFile? image = await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });

    await firebase_storage.FirebaseStorage.instance
        .ref("profile/${_auth.uid}")
        .putFile(File(_image!.path));
    downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref("profile/${_auth.uid}")
        .getDownloadURL();
    uploadURL = downloadURL;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.uid)
        .update({'photoURL': uploadURL});
  }

  Widget _editImage() {
    return CircleAvatar(
      backgroundColor: AppColors.grey[700],
      radius: 15.w,
      child: InkWell(
          onTap: () {
            print("OnTap");
            Get.bottomSheet(
              Wrap(children: [
                Card(
                  color: Colors.grey[200],
                  margin: EdgeInsets.fromLTRB(10.w, 0.0, 10.w, 0.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Wrap(
                    children: [
                      ListTile(
                        onTap: _getImageFromCam, dense: true, visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                        title: Center(child: textWidget('사진 찍기',TextStyle(fontSize: 14.sp))),
                      ),
                      dividerWidget(1),
                      ListTile(
                        onTap: _getImageFromGallery, dense: true, visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                        title: Center(child: textWidget('앨범에서 사진 선택',TextStyle(fontSize: 14.sp))),
                      ),
                    ],
                  ),
                ),
                Card(
                  color: AppColors.grey[100],
                  margin: EdgeInsets.fromLTRB(10.0.w, 7.0.w, 10.0.w, 15.0.w),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Wrap(
                    children: [
                      ListTile(
                        onTap: () {Get.back();},
                        dense: true, visualDensity: VisualDensity(horizontal: 0, vertical: -2),
                        title: Center(child: textWidget('닫기',TextStyle(fontSize: 14.sp))),
                      ),
                    ],
                  ),
                ),
              ]),
            );
          },
          child: Icon(Icons.camera_alt, color: Colors.white, size: 16.w)),
    );
  }
}
