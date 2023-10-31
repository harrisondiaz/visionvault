import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:visionvault/main.dart';
import 'package:visionvault/pages/feed.dart';

class FirebaseApi{
  //create an instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;
  //function to initialize notifications
  Future<void> initNotifications() async{
    // request permission from user(will prompt user)
    await _firebaseMessaging.requestPermission();
    // fetch the FMC token for this device
   // final fCMToken = await _firebaseMessaging.getToken();
    // print the token (normally you would send this to your server)
    //print("FCM Token: $fCMToken");

    // initialize further settings for push notifications
    initPushNotifications();
  }
  // function to handle received messages
  void handleMessage(RemoteMessage? message){
    //if the message is null ,do nothing
    if(message == null) return;

    // navigate to new screen if the user taps on the notification
    var snapshot = FirebaseAuth.instance.currentUser;
    Navigator.of(navigatorKey.currentContext!).push(MaterialPageRoute(builder: (context) => FeedPage(title: snapshot,index: 3,), settings: RouteSettings(arguments: message)));
  }
  // function to initialize background settings
  Future initPushNotifications() async{
    // handle notification if the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    // attach event listeners for when  a notification open the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }

}