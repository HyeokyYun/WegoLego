import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:livq/controllers/auth_controller.dart';
import 'package:livq/screens/my_page/sub_pages/individual_information.dart';
import 'package:livq/screens/my_page/sub_pages/terms_and_conditions.dart';
import 'package:livq/theme/colors.dart';
import 'package:livq/theme/text_style.dart';
import 'package:url_launcher/url_launcher.dart';
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

  FirebaseAuth auth = FirebaseAuth.instance;

  User? get userProfile => auth.currentUser;
  User? currentUser;

  var firebaseUser = FirebaseAuth.instance.currentUser;

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
    final _authController = Get.find<AuthController>();

    _nameController.text = userName;
    String title = "";
    FirebaseFirestore.instance
        .collection("users")
        .doc(userProfile!.uid)
        .get()
        .then((DocumentSnapshot ds) {
      photoURL = ds["photoURL"];
      print(photoURL);
    });

    Stream<DocumentSnapshot> _photoURLStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userProfile!.uid)
        .snapshots();
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
          "계정 / 정보 관리",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(28, 0, 28, 0),
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Column(
                children: [
                  ListTile(
                    title: Text(
                      '계정 정보',
                      style: AppTextStyle.koBody2.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            _image == null
                                ? StreamBuilder<DocumentSnapshot>(
                                    stream: _photoURLStream,
                                    builder: (context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      final getdata = snapshot.data;
                                      if (snapshot.hasData) {
                                        print(
                                            "for test ${getdata?["photoURL"]}");
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(57),
                                          child: Image.network(
                                            getdata?["photoURL"],
                                            height: 114.h,
                                            width: 114.w,
                                            fit: BoxFit.fill,
                                          ),
                                        );
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    },
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(57),
                                    child: Image.file(
                                      File(_image!.path),
                                      height: 114.h,
                                      width: 114.w,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                            Positioned(
                                child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: ((builder) =>
                                              bottomSheet()));
                                    },
                                    child: Icon(Icons.camera_alt,
                                        color: Colors.black45, size: 40)))
                          ],
                        ),
                        ifChangeName
                            ? ListTile(
                                title: Text(
                                  '이름 변경',
                                  style: AppTextStyle.koBody2.copyWith(
                                    color: AppColors.grey,
                                  ),
                                ),
                                subtitle: TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: _nameController.clear,
                                      icon: Icon(
                                        Icons.cancel,
                                        color: AppColors.grey[300],
                                      ),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.grey[300]!),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.grey[300]!),
                                    ),
                                  ),
                                  validator: (String? value) {
                                    if (value!.isEmpty)
                                      return 'Please enter some text';
                                    else if (value.length < 3)
                                      return 'Please enter more than 2';
                                    return null;
                                  },
                                ),
                                trailing: IconButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(userProfile!.uid)
                                          .update(
                                              {'name': _nameController.text});

                                      setState(() {
                                        setState(() {
                                          _authController.displayName =
                                              _nameController.text;
                                          firebaseUser?.updateDisplayName(
                                              _nameController.text);
                                          userName = _nameController.text;
                                          print(userName);
                                          ifChangeName = false;
                                        });
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    Icons.check,
                                    color: AppColors.grey[500],
                                  ),
                                ))
                            : ListTile(
                                title: Text(
                                  '이름',
                                  style: AppTextStyle.koBody2.copyWith(
                                    color: AppColors.grey,
                                  ),
                                ),
                                subtitle: Text(
                                  userName,
                                ),
                                trailing: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      ifChangeName = true;
                                    });
                                  },
                                  child: Text(
                                    "변경",
                                    style: AppTextStyle.koBody2
                                        .copyWith(color: Color(0xffFF5B5B)),
                                  ),
                                ),
                              ),
                        ListTile(
                          title: Text(
                            '이메일',
                            style: AppTextStyle.koBody2.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                          subtitle: Text(
                            widget.getEmail,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: AppColors.grey[400],
                  ),
                  ListTile(
                    title: Text(
                      '개인정보 처리방침',
                      style: AppTextStyle.koBody2.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 18.sp,
                      color: Color(0xffADB5BD),
                    ),
                    onTap: () async {
                      //웹페이지로 넘어갈 수 있도록 변경
                      Get.to(() => Information());
                      //https://wegolego.tistory.com/1
                      // if (!await launch("https://wegolego.tistory.com/1"))
                      //   throw 'Could not launch the website';
                    },
                  ),
                  Divider(
                    color: AppColors.grey[400],
                  ),
                  ListTile(
                    title: Text(
                      '이용 약관',
                      style: AppTextStyle.koBody2.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 18.sp,
                      color: Color(0xffADB5BD),
                    ),
                    onTap: () async {
                      //웹페이지로 넘어갈 수 있도록 변경
                      Get.to(() => Terms());
                      //https://wegolego.tistory.com/1
                      // if (!await launch("https://wegolego.tistory.com/2"))
                      //   throw 'Could not launch the website';
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            Text(
              'Choose profile photo',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: getImageFromCam,
                  tooltip: 'Pick Image',
                  child: Icon(Icons.add_a_photo),
                ),
                FloatingActionButton(
                  onPressed: getImageFromGallery,
                  tooltip: 'Pick Image',
                  child: Icon(Icons.wallpaper),
                )
              ],
            )
          ],
        ));
  }

  Future getImageFromCam() async {
    String? uploadURL;
    PickedFile? image =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
    await firebase_storage.FirebaseStorage.instance
        .ref("profile/${userProfile!.uid}")
        .putFile(File(_image!.path));
    downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref("profile/${userProfile!.uid}")
        .getDownloadURL();
    uploadURL = downloadURL;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userProfile!.uid)
        .update({'photoURL': uploadURL});
  }

  Future getImageFromGallery() async {
    String? uploadURL;
    PickedFile? image =
        await ImagePicker.platform.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });

    await firebase_storage.FirebaseStorage.instance
        .ref("profile/${userProfile!.uid}")
        .putFile(File(_image!.path));
    downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref("profile/${userProfile!.uid}")
        .getDownloadURL();
    uploadURL = downloadURL;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userProfile!.uid)
        .update({'photoURL': uploadURL});
  }
}
