import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:visionvault/utils/color.dart';

import '../dto/ideas.dart';

class IdeaByIdPage extends StatefulWidget {
  final Idea idea;
  IdeaByIdPage({super.key, required this.idea});

  @override
  State<IdeaByIdPage> createState() => _IdeaByIdPageState();
}

class _IdeaByIdPageState extends State<IdeaByIdPage> {
  final dio = Dio();

  void shared() {
    Share.share('check out my website https://example.com',
        sharePositionOrigin: Rect.fromLTWH(0, 0, 100, 100));
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.idea.IdeaTitle,
          style: GoogleFonts.montserrat(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: "#ff2301".toColor()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.network(widget.idea.IdeaImageURL),
              Row(
                children: [
                  LikeButton(
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.red : Colors.grey,
                        size: 30,
                      );
                    },
                  ),
                  IconButton(
                    onPressed: shared,
                    icon: Icon(Icons.share, color: Colors.black, size: 30),
                  ),
                ],
              ),
              Wrap(
                children: [
                  for (var tag in widget.idea.Tags)
                    Chip(
                      label: Text('#$tag'),
                      elevation: 20.0,
                    ),
                ],
              ),
              Text(
                widget.idea.IdeaDescription,
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
