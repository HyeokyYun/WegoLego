import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';


class NotificationService{
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  //String? token;
  static const String serverKey =
'AAAAYJGNJi4:APA91bEzEuA2FMkTx27heVa728NpaaKn7y51zfsT5wngt54-l8fYRuL4cf43d7baQM1lhzqwfpIpQAr8000X3qOk7EAEDtKuKeCSKMqp8l_jDmE5Ov9SxXqC2r8TPCuJp3fFnQRdNG-x' ;
  //NotificationService.getTokenAndUpdate(currentUserId);

  static getTokenAndUpdate(String username) async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    String? token = await firebaseMessaging.getToken();
    print("FirebaseMessaging token: $token");

    await FirebaseFirestore.instance.collection('users').doc(username).update({'token': token});
  }

  static Future sendNotification(String title, String message) async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    List<String> tokens = [];
    await firebaseMessaging.requestPermission(
        sound: true,
        badge: true,
        alert: true,
        provisional: false
    );
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
      for (var element in querySnapshot.docs) {
        tokens.add((element.data() as dynamic)["token"]);
      }
      //if (ds.data()!["token"] != null) {
      if (tokens != null) {
        //String userToken = ds.data()!["token"];
        await post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey',
            // replace $serverToken with your firebase messaging server token
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{
                'body': message,
                'title': title,
                //'click_action': 'FLUTTER_NOTIFICATION_CLICK'
              },
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '${Random().nextInt(100)}',
                'status': 'done',
                'view': 'orders',
                'screen': 'screen2',
                //'extradata': uid
              },

              //'to': userToken,
              'registration_ids': tokens
              // 'registration_ids': [
              //   'dGsnZYO9QyCtgaN_VRaJ1y:APA91bF3Ud_wYo7vLyregHcHnCxo3qALNLgHQUvgNZomLcKwSDB2zq4IqLMB9HYkgVjlJ9dYgyoIun3gi0GoryRqUTZ0lTS69CWKs8qe36KlhEWcnpDsbJ46eScwXrtQsyLnq4bHdRJM',
              //   'dypc7BwfQIKGLag7ecQtrp:APA91bFT8p37RGwW21TqT7Ys7bK-iMAgN3S-EZQ3WP7MlXtPABpTHHvr-Z9SYoV3jy9zI8lOcCRDWN8ljhLdIy4E_-wXtoj0T9gs-C-cBktZwRLvzjkptnKcSWrvn7IWKGGAr7shG7k7',
              //   'ce4Udk-qUUqBiI_Ay18rX6:APA91bHKmiqVZgS6MddgMpBqPTfMZKn4yAphyjG1yqukUbPu18_58ujWxwMkbeZplCOPhJkgmGsK6qSR69acPQEJZ9B1tMjYfAbMKyoJwmFqAxL_Xq5szw6a17oR0VkdBEVekpkbpz7N'
              // ]
            },
          ),
        );
      } else {
        print("unable to fetch admin device token from database");
      }
    } catch (e) {
      print("Error in sending notification");
      print(e);
    }
  }
}