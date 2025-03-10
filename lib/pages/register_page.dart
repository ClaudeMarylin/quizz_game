import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizz_game/components/components.dart';
import 'package:quizz_game/services/auth_service.dart';
import 'package:quizz_game/errors/error_utils.dart';
import 'package:quizz_game/pages/home_page.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  final String firstName;
  final String lastName;
  final String residence;
  final String newBirthDate;

  const RegisterPage({
    super.key,
    required this.onTap,
    required this.firstName,
    required this.lastName,
    required this.residence,
    required this.newBirthDate,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
    // text editing controllers
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    // sign user up method
    void signUserUp() async {
      // show loading circle
      showDialog(
        context: context, 
        builder: (context){
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // try creating the user
      try{
        // check if the password is confirmed
        if (passwordController.text == confirmPasswordController.text) {
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

          await FirebaseFirestore.instance
              .collection("users")
              .doc(userCredential.user!.uid)
              .set({
            "firstName": widget.firstName,
            "lastName": widget.lastName,
            "residence": widget.residence,
            "newBirthDate": widget.newBirthDate,
            "email": emailController.text.trim(),
            "createdAt": Timestamp.now(),
          });

          Navigator.pop(context);
        } else {
          // pop the loading circle
          //Navigator.pop(context);
          // show error message, passwords don't match
          showErrorMessage(context, "Passwords don't match!");
        }
        // pop the loading circle
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        print("Firebase Auth Error: ${e.code} - ${e.message}"); // Ajout du print

        // pop the loading circle
        Navigator.pop(context);
        // show error message
        showErrorMessage(context, e.code);
      }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.grey[300],
            appBar: MyAppBar(
              text: "Création compte",
            ),
            body: SafeArea(
                child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              const SizedBox(height: 25),
                              
                              // logo
                              const Icon(
                                  Icons.lock,
                                  size: 50,
                              ),
                      
                              const  SizedBox(height: 25),
                      
                              // let's create an account for you
                              Text(
                                  "Let\'s create an account for you!",
                                  style: TextStyle(
                                      color: Colors.grey[200],
                                      fontSize: 16,
                                  ),                                
                              ),
                      
                              const  SizedBox(height: 25),
                      
                              // email textfield
                              MyTextField(
                                  controller: emailController,
                                  hintText: "email",
                                  obscureText: false,
                              ),
                      
                              const  SizedBox(height: 10),
                      
                              // password textfield
                              MyTextField(
                                  controller: passwordController,
                                  hintText: "password",
                                  obscureText: true,
                              ),

                              const  SizedBox(height: 10),
                      
                              // confirm password textfield
                              MyTextField(
                                  controller: confirmPasswordController,
                                  hintText: "confirm password",
                                  obscureText: true,
                              ),
                      
                              const  SizedBox(height: 25),
                      
                              // sign in button
                              MyButton(
                                text: "Sign Up",
                                onTap: signUserUp,
                              ),
                      
                              const  SizedBox(height: 50),
                      
                              // or continue with
                              Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Divider(
                                              thickness: 0.5,
                                              color: Colors.grey[400],
                                          )
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                          child: Text(
                                              "Or Continue with",
                                              style: TextStyle(color: Colors.grey[700]),
                                          ),
                                      ),
                                      Expanded(
                                          child: Divider(
                                              thickness: 0.5,
                                              color: Colors.grey[400],
                                          )
                                      )
                                    ],
                                  ),
                              ),
                      
                              const  SizedBox(height: 50),
                      
                              // google + apple sign in buttons
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      // google button
                                      SquareTile(
                                        onTap: () async {
                                          UserCredential? userCredential = await AuthService().signInWithGoogle(
                                            firstName: widget.firstName,
                                            lastName: widget.lastName,
                                            residence: widget.residence,
                                            newBirthDate: widget.newBirthDate,
                                          );

                                          // Si l'inscription est réussie, rediriger vers la HomePage
                                          if (userCredential != null) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(builder: (context) => HomePage()),
                                            );
                                          }
                                        },
                                        imagePath: 'lib/images/google.png',
                                      ),
                                      
                                      const SizedBox(width: 10),
                      
                                      // apple button
                                      SquareTile(
                                        onTap: () {},
                                        imagePath: 'lib/images/apple.png',
                                      ),
                                  ],
                              ),
                      
                              const  SizedBox(height: 50),
                      
                              //register now
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      Text(
                                          "Already have an account?",
                                          style: TextStyle(
                                              color: Colors.grey[200],
                                          ),
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: widget.onTap,
                                        child: const Text(
                                            "Login now",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                            ),
                                        ),
                                      )
                                  ],
                              )
                          ],
                      ),
                    ),
                ),
            ),
        );
    }
}