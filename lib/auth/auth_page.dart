

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:visionvault/pages/home.dart';
import 'package:visionvault/pages/login.dart';

class AuthPage extends StatelessWidget{

  //function to toggle between login and register page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context,snapshot){

//function to toggle between login and register page


          //user is logged in
          if(snapshot.hasData){
           return HomeFeedPage();
          }
          //User is NOT logged in
          else{
            return LogInPage();
          }
        },

      )
    );
  }

}