import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:visionvault/dto/ideas.dart';
import 'package:http/http.dart' as http;
import 'package:visionvault/http/url.dart';
import 'package:visionvault/utils/color.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visionvault/pages/idea_by_id.dart';



class HomeFeedPage extends StatefulWidget {
  const HomeFeedPage({super.key});

  @override
  _HomeFeedPageState createState() => _HomeFeedPageState();
}

class _HomeFeedPageState extends State<HomeFeedPage>{
  //final String BASE_URL = "192.168.100.238:3030";
  var _ideas = [];
  var _idea;
  bool shimmer = false;

  void pickImage(int index){
    print(_ideas[index].IdeaTitle);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => IdeaByIdPage(idea:_ideas[index],)));

  }


  void share() {
    Share.share('check out my website https://example.com', sharePositionOrigin: Rect.fromLTWH(0, 0, 100, 100));
  }



  void fetchIdeas() async {
    try {
      setState(() {
        shimmer = true;
      });
      final response = await http.get(Uri.http(URL.BASE_URL, "/api/ideas"));
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

  void myFuncion(){
    print("Hola");
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchIdeas();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: myFuncion,
          icon: Icon(Icons.mode_edit, color: "#ff2301".toColor(),),
        ),
        backgroundColor: "#ff2301".toColor(), title: Text("VisionVault", style: GoogleFonts.raleway(fontSize: 20, fontWeight: FontWeight.bold),),
      ),
      body: MasonryGridView.builder(
        itemCount: _ideas.length,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context,index){
          final idea = _ideas[index]  ;
          return shimmer? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child : Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Stack(
                  children: [
                    ListTile(
                      title: Image.network(idea.IdeaImageURL),
                      contentPadding: const EdgeInsets.all(20),
                      subtitle:
                      Row(
                        textBaseline: TextBaseline.alphabetic,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(idea.IdeaTitle, style: GoogleFonts.raleway(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),),
                          ),
                          //SizedBox(width: 10,),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -10,
                      right: 10,
                      child: IconButton(
                          onPressed:
                          share
                          , icon: Icon(Icons.more_horiz, color: Colors.black,)),
                    ),
                  ],
                ),
              ),
            )
          ):ElevatedButton(onPressed: (){
                pickImage(index);
            }, child: Card(
              color: Colors.transparent,
              elevation: 0.0,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: share
                        , icon: Icon(Icons.more_horiz, color: Colors.black,)),
                  ),
                  InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IdeaByIdPage(idea: idea,),
                    ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(idea.IdeaImageURL,fit: BoxFit.cover,),
                  ),),
                  Text(idea.IdeaTitle, style: GoogleFonts.raleway(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.black),),

                ],
              ),
            ), style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, elevation: 0.0,padding: EdgeInsets.only(top: 20,right: 10,left: 10,bottom: 20),)
            ,);
        },
      ),
    );
  }



}
