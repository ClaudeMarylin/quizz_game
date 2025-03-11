import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizz_game/components/components.dart';
import 'package:quizz_game/quiz/quiz_service.dart';
import 'package:quizz_game/quiz/solve_quiz_page.dart';

class DisplayAllQuizzes extends StatelessWidget {
  final QuizService quizService = QuizService(); 

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        text: "Jouer à un quiz"
      ),

      drawer: MyDrawer(),
      
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: quizService.getQuizzesFromOtherUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur lors du chargement des quiz"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Aucun quiz disponible"));
          }

          // Liste des quiz
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var quiz = snapshot.data![index];

              return ListTile(
                title: Text(quiz["title"]),
                subtitle: Text("Créé par : ${quiz["authorId"]}"),
                trailing: ElevatedButton(
                  child: Text("Jouer"),
                  onPressed: () {
                    Navigator.pushNamed(
                      context, 
                      "/solve_quiz", 
                      arguments: quiz["id"], // Passe l'ID du quiz en argument
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
