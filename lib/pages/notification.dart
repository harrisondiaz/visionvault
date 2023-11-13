

import 'package:flutter/material.dart';
import 'package:visionvault/utils/color.dart';

class NotificationPage extends StatelessWidget{
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // get the notification message and display on screen
    /*final message = ModalRoute
        .of(context)!
        .settings
        .arguments as RemoteMessage;
    try{
      return Scaffold(
        appBar: AppBar(
          backgroundColor: "#ff2301".toColor(), title: Text("Notificaciones"),),
        body: Column(children: [
          Text(message.notification!.title.toString()),
          Text(message.notification!.body.toString()),
          Text(message.data.toString()),
        ]

        ),
      );
    }catch(e){*/
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back, color: "#ff2301".toColor(),),
          ),
          backgroundColor: "#ff2301".toColor(), title: const Text("Notificaciones"),),
        body: const Column(children: [
          Text("No hay notificaciones"),
        ]

        ),
      );
    //}
  }

}