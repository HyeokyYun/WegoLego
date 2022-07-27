import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthClass {
  User? get userProfile => FirebaseAuth.instance.currentUser;
  User? currentUser;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  var uid = FirebaseAuth.instance.currentUser?.uid;
  var name = FirebaseAuth.instance.currentUser?.displayName;


  Stream<DocumentSnapshot> UserStream() {
    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }


}
