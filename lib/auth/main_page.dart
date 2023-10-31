
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:visionvault/auth/auth_page.dart';
import 'package:visionvault/pages/feed.dart';



class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return FeedPage(title: snapshot.data);

          }else{
            return AuthPage();
          }
        }
      ),
    );
  }

}