import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visionvault/pages/home.dart';
import 'package:visionvault/pages/notification.dart';
import 'package:visionvault/pages/profile.dart';
import 'package:visionvault/pages/search.dart';
import 'package:visionvault/pages/upload.dart';
import 'package:visionvault/utils/color.dart';

class FeedPage extends StatefulWidget {
  final index;
  const FeedPage({Key? key, int? this.index})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<FeedPage> {
  //File? _image;



  Future signUserOut() async {
    await FirebaseAuth.instance.signOut();
  }





  int _currentIndex = 0;

  final screens = [
    HomeFeedPage(),
    SearchPage(),
    /*const Center(
      child: Text("Subir"),
    )*/
    null,
    NotificationPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            body: screens[_currentIndex],
            bottomNavigationBar: GNav(
              selectedIndex: _currentIndex,
              onTabChange: (index) {
                setState(() {
                  if (widget.index == 3) {
                  } else {
                    _currentIndex = index;
                  }
                });
              },
              iconSize: 25,
              activeColor: "#ff2301".toColor(),
              //haptic: true,
              //padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              tabs: [
                const GButton(
                  icon: Icons.home,
                  //text: 'Inicio',
                ),
                const GButton(
                  icon: Icons.search,
                  //text: 'Buscar',
                ),
                GButton(
                  icon: Icons.photo_camera,
                  onPressed: () {

                    Navigator.push(context, MaterialPageRoute(builder: (context) => UploadPage()));
                  },
                  //text: 'Subir',
                ),
                const GButton(
                  icon: Icons.notifications,
                  //text: 'notificaciones',
                ),
                const GButton(
                  icon: Icons.person,
                  //text: 'Perfil',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
