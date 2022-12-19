import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livq/models/user_model.dart';
import 'package:livq/repository/user_repository.dart';

class AuthClass {
  User? get userProfile => FirebaseAuth.instance.currentUser;
  User? currentUser;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  var uid = FirebaseAuth.instance.currentUser?.uid;
  var name = FirebaseAuth.instance.currentUser?.displayName;

  Stream<DocumentSnapshot> UserStream() {
    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }


  Stream<QuerySnapshot<Map<String, dynamic>>> CallHistoryStream() {
    return  FirebaseFirestore.instance.collection('users')
        .doc(uid)
        .collection('callHistory')
        .orderBy("timeRegister", descending: true)
        .snapshots();
  }
}

class UserStreamBuilder extends StatefulWidget {
  final String data;
  final TextStyle textStyle;

  const UserStreamBuilder(
      {Key? key, required this.data, required this.textStyle})
      : super(key: key);

  @override
  _UserStreamBuilderState createState() => _UserStreamBuilderState();
}

class _UserStreamBuilderState extends State<UserStreamBuilder> {
  AuthClass _auth = AuthClass();

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> _userStream = _auth.UserStream();
    return StreamBuilder<DocumentSnapshot>(
      stream: _userStream,
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        final getdata = snapshot.data;
        if (snapshot.hasData) {
          if (widget.data == 'photoURL') {
            return ClipRRect(
              borderRadius: BorderRadius.circular(57),
              child: Image.network(
                getdata?["photoURL"],
                height: 114.h,
                width: 108.w,
                fit: BoxFit.fill,
              ),
            );
          } else {
            return Text('${getdata?[widget.data]}', style: widget.textStyle);
          }
        } else {
          return Container();
        }
      },
    );
  }
}


class UserFutureBuilder extends StatefulWidget {
  final String data;
  final TextStyle textStyle;


  const UserFutureBuilder(
      {Key? key, required this.data, required this.textStyle,})
      : super(key: key);

  @override
  _UserFutureBuilderState createState() => _UserFutureBuilderState();
}

class _UserFutureBuilderState extends State<UserFutureBuilder> {
  AuthClass _auth = AuthClass();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel?>(
     future: UserRepositroy.getUser(_auth.uid.toString()),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            UserModel user = snapshot.data!;
            String input = widget.data;
            if(input=='photoURL'){
              return ClipRRect(
                borderRadius: BorderRadius.circular(57),
                child: Image.network(
                  "${user.photoURL}",
                  fit: BoxFit.fill,
                ),
              );
            } else if(input=='name'){
              return Text("${user.name}", style: widget.textStyle,);
            }
          }
          return Text('');
        });
  }
}
