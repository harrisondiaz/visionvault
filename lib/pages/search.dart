import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:visionvault/utils/color.dart';

import '../dto/ideas.dart';
import 'package:http/http.dart' as http;

import '../http/url.dart';
import 'idea_by_id.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  var _ideas = [];
  var items = [];
  var searchHistory = [];
  final TextEditingController _searchController = TextEditingController();

  void queryListener(){
    search(_searchController.text);
  }

  void search(String query){
    if(query.isNotEmpty){
      setState(() {
       items = _ideas.where((element) => element.IdeaTitle.toLowerCase().contains(query.toLowerCase())).toList();
      });
    }else{
      setState(() {
        items = _ideas;
      });
    }
  }


  void fetchIdeas() async {
    try {
      final response = await http.get(Uri.http(URL.BASE_URL, "/api/ideas"));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final ideas = data.map((item) => Idea.fromJson(item)).toList();
        setState(() {
          _ideas = ideas;
        });

      } else {
        print("La solicitud no fue exitosa. Código de estado: ${response.statusCode}");
      }
    } catch (e) {
      print("Error en la solicitud: $e");
    }
  }

  void pickImage(int index){
    print(_ideas[index].IdeaTitle);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => IdeaByIdPage(idea:_ideas[index],)));

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(queryListener);
    fetchIdeas();
  }

  @override
  void dispose() {
    _searchController.removeListener(queryListener);
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: MediaQuery.of(context).size.height * 0.07),
          child: Column(
            children: [
              Center(
                child: SearchBar(
                  controller: _searchController,
                  hintText: "Buscar",
                  leading: Icon(Icons.search),
                ),
              ),
              ListView.builder(
                itemCount: items.isEmpty? _ideas.length: items.length,
                itemBuilder: (context, index){
                final idea = items.isEmpty? _ideas[index]: items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, top: 20.0, left: 10.0, right: 10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      pickImage(index);

                    },
                    child: Card(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Image.network(idea.IdeaImageURL, width: MediaQuery.of(context).size.width),
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: Column(
                                  children: [
                                    Text(idea.IdeaTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                    Text(idea.IdeaDescription, style: TextStyle(fontSize: 15),),
                                    Wrap(
                                      children: [
                                        for (var tag in idea.Tags)
                                          Chip(
                                            label: Text('#$tag'),
                                            // labelPadding: EdgeInsets.all(2),
                                            elevation: 20.0,
                                          ),

                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: LikeButton(
                              mainAxisAlignment: MainAxisAlignment.start,
                              likeBuilder: (bool isLiked) {
                                return Icon(
                                  Icons.favorite,
                                  color: isLiked ? Colors.red : Colors.grey,
                                  size: 30,
                                );
                              },
                            ),
                            ),

                        ],
                      ),
                    ),
                  )
                );
              },
                shrinkWrap: true,
                physics: PageScrollPhysics(),
              )
            ],
          )

        )
      )
    );
  }
}

