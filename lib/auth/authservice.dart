

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {


    //sign in with Google
  signInWithGoogle() async{
    //Begin interactive sigin process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //obtain auth details from resquest
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    //create a new credential for user
    final credencial = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken
    );

    //finally, let's sign in
    return await FirebaseAuth.instance.signInWithCredential(credencial);
  }

}