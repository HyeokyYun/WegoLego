import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livq/models/user_model.dart';


class UserRepositroy {
  static final userCollection = FirebaseFirestore.instance.collection('users');

  static Future<UserModel?> getUser(String uid) async {
    var ds = await userCollection.doc(uid).get();
    return UserModel.fromSnapshot(ds);
  }
}