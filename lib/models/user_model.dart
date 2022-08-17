import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  int? ask;
  String? email;
  bool? feedback;
  int? getHeart;
  int? help;
  String? name;
  bool? notificationOn;
  String? photoURL;
  String? timeRegister;
  String? token;
  String? uid;

  UserModel(
      {this.ask,
      this.email,
      this.feedback,
      this.getHeart,
      this.help,
      this.name,
      this.notificationOn,
      this.photoURL,
      this.timeRegister,
      this.token,
      this.uid});

  List<UserModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap = snapshot.data() as Map<String, dynamic>;

      return UserModel(
          ask: dataMap['ask'],
          email: dataMap['email'],
          feedback: dataMap['feedback'],
          getHeart: dataMap['getHeart'],
          help: dataMap['help'],
          name: dataMap['name'],
          notificationOn: dataMap['notificationOn'],
          photoURL: dataMap['photoURL'],
          timeRegister: dataMap['timeRegister'],
          token: dataMap['token'],
          uid: dataMap['uid']);
    }).toList();
  }

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : ask = snapshot['ask'],
        email = snapshot['email'],
        feedback = snapshot['feedback'],
        getHeart = snapshot['getHeart'],
        help = snapshot['help'],
        name = snapshot['name'],
        notificationOn = snapshot['notificationOn'],
        photoURL = snapshot['photoURL'],
        timeRegister = snapshot['timeRegister'],
        token = snapshot['token'],
        uid = snapshot['uid'];
}
