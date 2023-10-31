import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visionvault/pages/home.dart';
import 'package:visionvault/pages/notification.dart';
import 'package:visionvault/pages/profile.dart';
import 'package:visionvault/utils/color.dart';

class FeedPage extends StatefulWidget{
  final  title;
  final index;
  const FeedPage({Key? key, required this.title,  int? this.index}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }

}

class _HomePageState extends State<FeedPage>{

  //File? _image;

  Future getImage() async{
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    print(image!.path);
    return image;
  }

  Future getCamera() async{
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    print(image!.path);
    return image;
  }



  Future signUserOut() async{
    await FirebaseAuth.instance.signOut();
  }

  Future _displayCamera(BuildContext context){
    return showModalBottomSheet(
        context: context,
        isDismissible: true,

        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.15,
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Cámara"),
                onTap: getCamera,
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Galería"),
                onTap: getImage,
              ),
            ],

          ),

        ),

    );
  }



  DisplayName(){

    if(widget.title.displayName == null) {
      return "¡Hola de nuevo! 👀";
    }else{
      return "¡Hola!, ${widget.title.displayName!}";
    }
  }


  int _currentIndex = 0;

  final screens = [
    HomeFeedPage(),
    const Center(
      child: Text("Buscar"),
    ),
    /*const Center(
      child: Text("Subir"),
    )*/null,
     NotificationPage(),
     ProfilePage(),
  ];


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: GNav(
          selectedIndex: _currentIndex,
          onTabChange: (index) {
            setState(() {
              if( widget.index == 3){
              }else{
                _currentIndex = index;              }
            });
          },
          gap: 5,
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
              onPressed: (){
                _displayCamera(context);
              },
              //text: 'Subir',
            ),
            const GButton(
              icon: Icons.notifications,
              //text: 'notificaciones',
            ),
            const GButton(
              icon: Icons.person,
             // text: 'Perfil',
            ),
          ],
          ),
    );

  }
  
}