import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizz_game/components/components.dart'; // Assure-toi que MyButton est bien importé

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  // Méthode pour déconnecter l'utilisateur
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "LOGGED IN AS: ${user.email!}",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),

            // Bouton pour aller vers la création de quiz
            MyButton(
              text: "Créer un Quiz",
              onTap: () {
                Navigator.pushReplacementNamed(context, '/create_quiz');
              },
            ),
          ],
        ),
      ),
    );
  }
}
