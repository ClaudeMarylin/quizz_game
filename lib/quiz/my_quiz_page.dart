import 'package:intl/intl.dart'; // Importer intl
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizz_game/components/components.dart';
import 'package:quizz_game/quiz/quiz_service.dart';
import 'package:quizz_game/quiz/quiz_detail_page.dart';

class MyQuizPage extends StatelessWidget {
  final QuizService quizService = QuizService(); // Instance de notre service

  // Fonction pour formater le Timestamp en une date lisible
  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate(); // Convertir le Timestamp en DateTime
    // Formater la date avec intl
    var formatter = DateFormat("d MMMM yyyy 'à' HH:mm:ss 'UTC'Z");
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        text: "Mes Quiz"
      ),

      drawer: MyDrawer(),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: quizService.getQuizzesByUser(), // Fonction qui récupère les quiz
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun quiz trouvé.'));
          } else {
            List<Map<String, dynamic>> quizzes = snapshot.data!; // Les données récupérées

            return ListView.builder(
              itemCount: quizzes.length,
              itemBuilder: (context, index) {
                var quiz = quizzes[index]; // Chaque quiz
                // Récupérer le Timestamp
                var createdAt = quiz['createdAt'];
                var formattedDate = formatDate(createdAt);
                print("id : " + (quiz['id'] ?? 'ID inconnu'));

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(quiz['title'] ?? 'Sans titre'),
                    subtitle: Text("Créé le : $formattedDate"),
                    onTap: () {
                      // Action au tap, redirection vers une autre page (par exemple pour éditer le quiz)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizDetailPage(quizId: quiz['id']),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
