
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visionvault/auth/authservice.dart';
import 'package:visionvault/pages/logup.dart';
import 'package:visionvault/utils/color.dart';

class LogInPage extends StatefulWidget {

  const LogInPage({Key? key,}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LogInPageState();
  }
}

class _LogInPageState extends State<LogInPage>{
  // Text Controller
  final _emailController = TextEditingController();
  final _PasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _PasswordController.dispose();
    super.dispose();
  }


  void signUserIn() async{

    // show loading circle
    showDialog(context: context,
    builder: (context) {
      return const Center(child: CircularProgressIndicator(),);

    }
    );
    // try sign in
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password:  _PasswordController.text );
      // pop loading circle
     Navigator.pop(context);
    } on FirebaseAuthException catch(e){
      print(e);
      // pop loading circle
     Navigator.pop(context);
      if(e.code == 'user-not-found'){
        userDonotExistDialog(context);
      }else if(e.code == 'wrong-password'){
        wrongPasswordDialog(context);
      } else  {
        print('invalid-login-credentials');
        error(context);
      }
    }
  }

  void error(BuildContext context){
      AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          autoHide: const Duration(seconds: 3),
          title: 'Error',
          desc: 'Ha ocurrido un error inesperado',

      ).show();
  }

  void wrongPasswordDialog(BuildContext context){
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.bottomSlide,
      title: 'Error',
      desc: 'Contraseña incorrecta',
    ).show();
  }

  void userDonotExistDialog(BuildContext context){
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.bottomSlide,
        title: 'Error',
        desc: 'Usuario no encontrado',
      ).show();
  }

  bool obs = true;
  void tooggleObs(){
    setState(() {
      obs = !obs;
    });
  }

  void GoogleSignIn(){
    AuthService().signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.grey[300],
        body:SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Logo
                  Image.asset("assets/images/logo.png",
                    width: 150,
                  ),
                  const SizedBox(height: 25,),
                  //Hello Again!
                  Text("¡Hola otra vez!",
                    style:
                    GoogleFonts.bebasNeue(
                      fontSize: 52,

                    ),
                  ),
                  const SizedBox(height: 10,),
                  const Text("Bienvenido de nuevo a VisionVault",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  //Email text field
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child:TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: "Correo electronico",
                              ),
                            )
                        ),
                      )
                  ),
                  const SizedBox(height: 10,),
                  //password text field
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child:TextField(
                              controller: _PasswordController,
                              obscureText: obs,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: "Contraseña",

                              ),

                            )
                        ),
                      )
                  ),
                  const SizedBox(height: 10,),
                  //Sign in button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child:  Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: "#ff2301".toColor(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          fixedSize: const Size(400, 50),
                        ),
                        onPressed: () {
                          signUserIn();
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
                        },
                        child: const Text(
                          "Iniciar sesión",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  //or sign in with
                  const Text("O inicia sesión con",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10,),
                  //or sign in with google
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: SizedBox(
                        child: Row ( mainAxisAlignment: MainAxisAlignment.center,children: [
                          GestureDetector(onTap: GoogleSignIn,
                            child: Container(
                              width: 300,
                              height: 50,
                            decoration: BoxDecoration(
                               color: Colors.grey[200],
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            child: Row( mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Image.asset("assets/images/google.png",
                                  width: 22,
                                  ),
                                  const SizedBox(width: 20),
                                  const Text("Iniciar sesión con Google")
                                  ],  ),
                                )
                            )
                        ],)
                    ),
                  ),

                  //not a member? register now
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿No tienes cuenta?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(onTap:
                        (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LogUpPage()));
                        }
                          , child: const Text(" Registrate",

                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        )
                        )
                      ],
                    ),
                  ),

                  //Condiciones de servicio
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Al iniciar sesión, aceptas nuestros ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(onTap: (){},
                          child: const Text("Términos de servicio",

                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),


                ],),
            ),
          ),
        )
    );
  }

}