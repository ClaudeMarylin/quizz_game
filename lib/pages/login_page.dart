import 'package:flutter/material.dart';
import 'package:quizz_game/components/components.dart';

class LoginPage extends StatelessWidget {
    LoginPage({super.key});

    // text editing controllers
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    // sign user in method
    void signUserIn() {

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

                            // username textfield
                            MyTextField(
                                controller: usernameController,
                                hintText: "username",
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