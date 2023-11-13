

import 'dart:collection';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visionvault/tabs/Thought.dart';
import 'package:visionvault/utils/color.dart';
import 'package:http/http.dart' as http;


import '../dto/ideas.dart';
import '../http/url.dart';
import 'idea_by_id.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State{

  User? user = FirebaseAuth.instance.currentUser;

  final List<Widget> tabsView = [
      Thought(),
  ];

  var _ideas = [];
  var _idea;
  bool shimmer = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchIdeas();
  }

  void fetchIdeas() async {
    try {
      setState(() {
        shimmer = true;
      });
      final response = await http.get(Uri.http(URL.BASE_URL, "/api/throughts/"+FirebaseAuth.instance.currentUser!.email.toString()));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final ideas = [];
        for (var i = 0; i < data.length; i++) {
          ideas.add(Idea.fromJson(data[i]));
        }
        print(ideas);
        setState(() {
          _ideas = ideas;
        });

        return Future.delayed(Duration(seconds: 5),(){
          setState(() {
            shimmer = false;
          });
        });
      } else {
        print("La solicitud no fue exitosa. Código de estado: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en la solicitud: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        /*appBar: AppBar(
          centerTitle: true,
          title: Text("Perfil"),
          backgroundColor: "#ff2301".toColor(),
        ),*/
        body: SafeArea(child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.all(20),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: "#ff2301".toColor(), width: 2),
                      image: DecorationImage(
                        image: NetworkImage(user?.photoURL??"https://i.pinimg.com/564x/dc/6c/b0/dc6cb0521d182f959da46aaee82e742f.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(user?.displayName??"Nombre de usuario", style: GoogleFonts.raleway(fontSize: 20, fontWeight: FontWeight.bold),),
                ],
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: ElevatedButton(
                        onPressed: (){},
                        child:Text("Editar Perfil", style: TextStyle(color: Colors.black),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                        )
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20.0, top: 20, bottom: 20, left: 10),
                    child: ElevatedButton(
                        onPressed: (){},
                        child:Row(children: [Text("Cerrar Sesión", style: TextStyle(color: Colors.white),),IconButton(onPressed:()=> FirebaseAuth.instance.signOut(), icon: Icon(Icons.logout, color: Colors.white,),)],),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        )
                    ),
                  ),
                ),
              ],
            ),
            //Divider(color: "#ff2301".toColor(),height: 20,thickness: 2,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Spacer(),
                Icon(CupertinoIcons.photo_on_rectangle, color: "#ff2301".toColor(),),
                Spacer(),
                Text("Mis Pensamientos", style: GoogleFonts.raleway(fontSize: 20, fontWeight: FontWeight.bold,color: "#ff2301".toColor()),),
                Spacer(),
                Spacer(),
              ],
            ),
            Divider(color: "#ff2301".toColor(),height: 20,thickness: 2,),
            Expanded(
              child: Padding(padding: EdgeInsets.only(bottom: 10),
                child: MasonryGridView.builder(
                    itemCount: _ideas.length,
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: (context,index){
                      return shimmer? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Card(
                            child: Image.network("https://i.pinimg.com/564x/dc/6c/b0/dc6cb0521d182f959da46aaee82e742f.jpg",fit: BoxFit.cover,),
                          )

                      ): ElevatedButton(

                        onPressed: (){}, child:
                      Card(
                        color: Colors.transparent,
                        elevation: 0.0,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IdeaByIdPage(idea: _ideas[index],),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(_ideas[index].IdeaImageURL,fit: BoxFit.cover,),
                              ),),
                            Text(_ideas[index].IdeaTitle, style: GoogleFonts.raleway(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.black),),

                          ],
                        ),
                      ), style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, elevation: 0.0,padding: EdgeInsets.only(top: 20,right: 10,left: 10,bottom: 20),)
                        ,

                      );
                    }),
              )
            ),
          ],
        ),)
        ,
      ),

    );
  }

}

