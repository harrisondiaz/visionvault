


import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visionvault/dto/ideas.dart';
import 'package:visionvault/pages/feed.dart';
import 'package:visionvault/utils/color.dart';
import 'package:http/http.dart' as http;
import '../http/url.dart';
import 'home.dart';

class UploadPage extends StatefulWidget{
  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {

  XFile? _file;
  UploadTask? task;
  String urlImage = "";
  final _tittleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();


  Future uploadFile() async{
    final path = "ideas/${_file?.name!}";
    final file = File(_file!.path!);

    final ref = await FirebaseStorage.instance.ref().child(path);
    task = ref.putFile(file);

    final snapshot = await task!.whenComplete(() => null);

    final urlDownload = await snapshot.ref.getDownloadURL();
    setState(() {
      urlImage = urlDownload;
    });
  }


  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _file = image;
    });
    Navigator.pop(context);
  }

  Future getCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _file = image;
    });
    Navigator.pop(context);
  }

  Future _displayCamera(BuildContext context) {
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

  Future postIdea(Map<String, dynamic> body) async{
      final uri = Uri.http(URL.BASE_URL,"/api/newideas");
      final response = await http.post(uri, body: body);
      if(response.statusCode == 200){
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Exito',
          desc: 'Se subio la idea correctamente',
        )..show();
        Navigator.pop(context);
      }else{
        AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Error',
          desc: 'No se pudo subir la idea',
        )..show();
      }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tittleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
  }


  @override
  Widget build(BuildContext context ) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            appBar: AppBar(
              title: Text("Subir idea"),
              centerTitle: true,
              backgroundColor: "#ff2301".toColor(),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FeedPage(index:0)));
                },
              ),
            ),
            body: Padding(padding: EdgeInsets.all(20),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(_file != null) Expanded(child: Image.file(File(_file!.path!),fit: BoxFit.cover,),) else Container(
                      height: 200,
                      width: 200,
                      color: Colors.grey,
                    ),
                    ElevatedButton(
                      onPressed: (){
                        _displayCamera(context);
                      },
                      child: Text("Seleccionar archivo"),
                      style: ElevatedButton.styleFrom(
                        primary: "#ff2301".toColor(),
                        onPrimary: Colors.white,
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 2,color: "#ff2301".toColor(),height: 20,),
                Text("Titulo de la idea", style: GoogleFonts.raleway(fontSize: 12, fontWeight: FontWeight.bold),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _tittleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Título',
                    ),
                  ),
                ),
                Text("Descripción de la idea", style: GoogleFonts.raleway(fontSize: 12, fontWeight: FontWeight.bold),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Descripción',
                    ),
                  ),
                ),
                Text("Etiquetas de la idea(por favor separar por comas(,))", style: GoogleFonts.raleway(fontSize: 12, fontWeight: FontWeight.bold),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _tagsController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      labelText: 'Etiquetas',
                    ),
                  ),
                ),
                Spacer(),
              ],

            ),

            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if(_file != null){
                  uploadFile();
                  final tags = _tagsController.text.split(",");
                  Idea idea = new Idea(IdeaID: 0, ThoughtID: 1, IdeaTitle: _tittleController.text, IdeaDescription: _descriptionController.text, IdeaImageURL: urlImage, Tags: tags, CreatedBy: FirebaseAuth.instance.currentUser!.email!);
                  print(idea.toJson());
                  postIdea(idea.toJson());
                }else{
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'Error',
                    autoHide: Duration(seconds: 3),
                    desc: 'No se ha seleccionado un archivo',
                  )..show();
                }

              },
              child: Icon(Icons.upload),
              backgroundColor: CupertinoColors.activeGreen,
            ),
            )
          )
        ),
      );
  }
}