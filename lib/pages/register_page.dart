import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizz_game/components/components.dart';
import 'package:quizz_game/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({
    super.key,
    required this.onTap
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
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text, 
            password: passwordController.text,
          );
        } else {
          // pop the loading circle
          //Navigator.pop(context);
          // show error message, passwords don't match
          showErrorMessage("Passwords don't match!");
        }
        // pop the loading circle
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        print("Firebase Auth Error: ${e.code} - ${e.message}"); // Ajout du print

        // pop the loading circle
        Navigator.pop(context);
        // show error message
        showErrorMessage(e.code);
      }
    }

    // error message to user
    void showErrorMessage(String message) {
      if (!mounted) return; // Vérifie si le widget est toujours actif

      ScaffoldMessenger.of(context).clearSnackBars(); // Supprime les anciens SnackBars avant d'afficher un nouveau
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 16), // Ajuste la hauteur ici
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16), // Ajoute un peu d'espace autour
          elevation: 6, // Ajoute une ombre pour un meilleur effet
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Arrondit les bords
          ),
        ),
      );
    }



    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.grey[300],
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
                                        onTap: () => AuthService().signInWithGoogle(),
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