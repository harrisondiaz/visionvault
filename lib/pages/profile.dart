

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:visionvault/utils/color.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State{

  var user = FirebaseAuth.instance.currentUser;
  User? user2 = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: "#ff2301".toColor(), title: Text(user?.displayName??"No hay nada", style: TextStyle(color: Colors.white),),
        actions: [
          //logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: const Column(children: [
        Text("Perfil"),
      ]

      ),
    );
  }

}

