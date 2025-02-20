import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizz_game/components/components.dart';

class LoginPage extends StatefulWidget {
    LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    // text editing controllers
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    // sign user in method
    void signUserIn() async {
      // show loading circle
      showDialog(
        context: context, 
        builder: (context){
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // try sign in
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, 
          password: passwordController.text,
        );
        // pop the loading circle
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        print("Firebase Auth Error: ${e.code} - ${e.message}"); // Ajout du print

        // pop the loading circle
        Navigator.pop(context);
        // Wrong email
        if (e.code == 'user-not-found') {
          // show error to user
          wrongEmailMessage();
        } 
        
        // Wrong password
        else if (e.code == "wrong-password") {
           // show error to user 
          wrongPasswordMessage();
        }
      }
    }

    // wrong email message popup
    void wrongEmailMessage() {
      showDialog(
        context: context, 
        builder: (context) {
          return const AlertDialog(
            title: Text("Incorrect Email"),
          );
        },
      );
    }

    void wrongPasswordMessage() {
      showDialog(
        context: context, 
        builder: (context) {
          return const AlertDialog(
            title: Text("Incorrect Password"),
          );
        },
      );
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.grey[300],
            body: SafeArea(
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            const SizedBox(height: 50),
                            
                            // logo
                            const Icon(
                                Icons.lock,
                                size: 100,
                            ),

                            const  SizedBox(height: 50),

                            Text(
                                "Welcome back you\'ve been missed!",
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
                            
                            const  SizedBox(height: 25),

                            // forgot password
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                        Text(
                                            "Forgot password ?",
                                            style: TextStyle(color: Colors.grey[600]),
                                        ),
                                    ],
                                ),
                            ),

                            const  SizedBox(height: 25),

                            // sign in button
                            MyButton(
                                onTap: signUserIn,
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
                                    SquareTile(imagePath: 'lib/images/google.png'),
                                    
                                    const SizedBox(width: 10),

                                    // apple button
                                    SquareTile(imagePath: 'lib/images/apple.png'),
                                ],
                            ),

                            const  SizedBox(height: 50),

                            //register now
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Text(
                                        "Not a member?",
                                        style: TextStyle(
                                            color: Colors.grey[200],
                                        ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                        "Register now",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                        ),
                                    )
                                ],
                            )
                        ],
                    ),
                ),
            ),
        );
    }
}