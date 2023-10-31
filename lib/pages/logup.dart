
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visionvault/auth/authservice.dart';
import 'package:visionvault/pages/login.dart';
import 'package:visionvault/utils/color.dart';

class LogUpPage extends StatefulWidget {
  const LogUpPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LogUpPageState();
  }
}

class _LogUpPageState extends State<LogUpPage> {
  // text controller
  final _emailController = TextEditingController();
  final _PasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _PasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future signUp() async {
    showDialog(context: context, builder: (BuildContext context) {
      return const Center(child: CircularProgressIndicator(),);
    });

    if (passwordConfirmed()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _PasswordController.text.trim()
        );
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        if (e.code == 'weak-password') {
          weakPasswordMessage();
        } else if (e.code == 'email-already-in-use') {
          emailAlreadyInUseMessage();
        }
      } catch (e) {
        Navigator.pop(context);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.topSlide,
          title: '¡Error!',
          desc: 'Ha ocurrido un error',
          autoHide: const Duration(seconds: 3),
        ).show();
      }
    } else {
      Navigator.pop(context);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.topSlide,
        title: '¡Error!',
        desc: 'Las contraseñas no coinciden',
        autoHide: const Duration(seconds: 3),
      ).show();
    }
  }

  void emailAlreadyInUseMessage(){
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.topSlide,
      title: '¡Error!',
      desc: 'El correo ya esta en uso',
      autoHide: const Duration(seconds: 3),
    ).show();
  }

  GoogleSignIn() async {
    // loading Circle
    //sign in with Google
    await AuthService().signInWithGoogle();

    //Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainPage()));
    //Navigator.of(context).pop();
  }

  void weakPasswordMessage() {
    showDialog(context: context, builder: (BuildContext context) {
      return const AlertDialog(
        title: Text("¡Error!"),
        content: Text("La contraseña es muy debil"),
      );
    });
  }


  bool passwordConfirmed() {
    if (_PasswordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Logo
                  Image.asset("assets/images/logo.png",
                    width: 150,
                  ),
                  const SizedBox(height: 25,),
                  //Register
                  Text("Registrate",
                    style:
                    GoogleFonts.bebasNeue(
                      fontSize: 52,

                    ),
                  ),
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
                            child: TextField(
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
                            child: TextField(
                              controller: _PasswordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: "Contraseña",
                              ),
                            )
                        ),
                      )
                  ),
                  const SizedBox(height: 10,),
                  //password confirm text field
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
                            child: TextField(
                              controller: _confirmPasswordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: "Confirmar contraseña",
                              ),
                            )
                        ),
                      )
                  ),
                  const SizedBox(height: 10,),
                  //Sign in button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Padding(
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
                          signUp();
                        },
                        child: const Text(
                          "Registrarse",
                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  //or sign in with
                  const Text("O registrate con",
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

                  //is a member? sign in
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿Ya tienes cuenta?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(onTap:
                            () {
                               Navigator.push(context, MaterialPageRoute(builder: (context) => const LogInPage()));
                            }
                            , child: const Text(" Inicia Sesión",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                )
                            ))
                        ,
                      ],
                    ),
                  ),

                  //Condiciones de servicio
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Al registrarte, aceptas nuestras "),
                        GestureDetector(onTap: () {
                          print("Condiciones de servicio");
                        }, child: const Text("Condiciones de servicio",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            )
                        ))
                        ,
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