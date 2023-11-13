


import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../dto/ideas.dart';
import '../http/url.dart';
import 'package:http/http.dart' as http;

import '../pages/idea_by_id.dart';

class Thought extends StatefulWidget {
  @override
  _ThoughtState createState() => _ThoughtState();
}

class _ThoughtState extends State{

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
    return Padding(padding: EdgeInsets.only(bottom: 10),
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
        );
      }
}