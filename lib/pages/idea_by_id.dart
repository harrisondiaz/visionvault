import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:path_provider/path_provider.dart';
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
    Share.share('¡Hey! mira mi estupenda idea!!!\n'+Faker().internet.httpsUrl(),
        sharePositionOrigin: Rect.fromLTWH(0, 0, 100, 100));
  }

  void download() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    var dir = await getExternalStorageDirectory();
    await dio.download(widget.idea.IdeaImageURL, "${dir!.path}/idea.jpg");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.idea.IdeaImageURL),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: CircleAvatar(
                                backgroundColor: Colors.black.withOpacity(0.2),
                                child: const Icon(
                                  CupertinoIcons.chevron_back,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.3,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 16),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                IconButton(onPressed: ()=>Navigator.pop(context), icon: Icon(Icons.close, color: Colors.black,)),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                Text(
                                                  'Opciones',
                                                  style: GoogleFonts.notoSans(),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            Text(
                                              'Autor ${Faker().internet.userName()}',
                                              style: GoogleFonts.notoSans(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              'Copiar link',
                                              style: GoogleFonts.notoSans(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              'Descargar imagen',
                                              style: GoogleFonts.notoSans(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                );
                              },
                              child: const Icon(
                                  CupertinoIcons.ellipsis,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.8),
                          child: const Icon(
                            CupertinoIcons.viewfinder,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 30,
                left: 18,
                right: 18,
              ),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LikeButton(
                    size: 30,
                    circleColor: const CircleColor(
                      start: Color(0xff00ddff),
                      end: Color(0xff0099cc),
                    ),
                    bubblesColor: const BubblesColor(
                      dotPrimaryColor: Color(0xff33b5e5),
                      dotSecondaryColor: Color(0xff0099cc),
                    ),
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                        size: 30,
                      );
                    },
                  ),
                  Row(
                    children: [
                      ElevatedButton(onPressed: download,
                          child: Row(
                            children: [
                              const Icon(Icons.download),
                              const SizedBox(width: 5,),
                              const Text("Descargar")
                            ],
                          ),
                            style: ElevatedButton.styleFrom(
                            primary: "#ff2301".toColor(),
                            onPrimary: Colors.white,
                          ),),
                    ],
                  ),
                  IconButton(onPressed: shared, icon: const Icon(Icons.share)),
                ],
              ),
            ),
          ],
        ),
      );
  }
}
