import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:visionvault/auth/main_page.dart';
import 'package:visionvault/utils/firebase_api.dart';

import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main () async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  }
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  //await FirebaseAppCheck.instance.activate(androidProvider: AndroidProvider.playIntegrity,);
  //print(FirebaseAppCheck.instance.getToken());
  runApp(const MyApp() );
}




class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
      navigatorKey: navigatorKey,
    );
  }

}

