import 'package:firebase_auth/firebase_auth.dart';

class AuthClass {
  User? get userProfile => FirebaseAuth.instance.currentUser;
  User? currentUser;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  var uid = FirebaseAuth.instance.currentUser?.uid;
  var name = FirebaseAuth.instance.currentUser?.displayName;
}
