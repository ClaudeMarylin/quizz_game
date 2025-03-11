import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizz_game/components/components.dart';

class QuizDetailPage extends StatefulWidget {
  final String quizId; // ID du quiz pour lequel nous allons gérer les questions

  const QuizDetailPage({super.key, required this.quizId});

  @override
  _QuizDetailPageState createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage> {
  late TextEditingController questionController;
  late TextEditingController answerController;
  late List<TextEditingController> optionControllers;
  bool isMultipleChoice = false; // Nouveau: Indique si c'est un QCM
  late CollectionReference questionsRef;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController();
    answerController = TextEditingController();
    optionControllers = [TextEditingController()]; // Au moins un champ par défaut
    questionsRef = FirebaseFirestore.instance.collection("quizzes").doc(widget.quizId).collection("questions");
  }

  @override
  void dispose() {
    questionController.dispose();
    answerController.dispose();
    for (var controller in optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Fonction pour ajouter une question
  Future<void> addQuestion() async {
    if (questionController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Erreur"),
          content: const Text("Veuillez remplir la question."),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("OK"))],
        ),
      );
      return;
    }

    try {
      Map<String, dynamic> questionData = {
        "question": questionController.text.trim(),
        "isMultipleChoice": isMultipleChoice,
        "createdAt": Timestamp.now(),
      };

      if (isMultipleChoice) {
        List<String> options = optionControllers.map((controller) => controller.text.trim()).where((text) => text.isNotEmpty).toList();
        if (options.isEmpty || answerController.text.trim().isEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Erreur"),
              content: const Text("Veuillez entrer des options et une réponse correcte."),
              actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("OK"))],
            ),
          );
          return;
        }

        questionData["options"] = options;
        questionData["correctAnswer"] = answerController.text.trim();
      } else {
        if (answerController.text.trim().isEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Erreur"),
              content: const Text("Veuillez entrer une réponse correcte."),
              actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("OK"))],
            ),
          );
          return;
        }

        questionData["correctAnswer"] = answerController.text.trim();
      }

      await questionsRef.add(questionData);

      // Réinitialiser le formulaire
      questionController.clear();
      answerController.clear();
      setState(() {
        isMultipleChoice = false;
        optionControllers = [TextEditingController()];
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Erreur"),
          content: const Text("Erreur lors de l'ajout de la question."),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("OK"))],
        ),
      );
    }
  }

  // Fonction pour supprimer une question
  Future<void> deleteQuestion(String questionId) async {
    try {
      await questionsRef.doc(questionId).delete();
    } catch (e) {
      // Afficher une erreur si la suppression échoue
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Erreur"),
          content: Text("Erreur lors de la suppression de la question."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(text: "Gestion des Questions"),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(controller: questionController, decoration: const InputDecoration(hintText: "Entrez la question")),
          ),
          
          SwitchListTile(
            title: const Text("Question à choix multiple ?"),
            value: isMultipleChoice,
            onChanged: (value) {
              setState(() {
                isMultipleChoice = value;
              });
            },
          ),

          if (isMultipleChoice) ...[
            Column(
              children: optionControllers.map((controller) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(controller: controller, decoration: const InputDecoration(hintText: "Option")),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            optionControllers.remove(controller);
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  optionControllers.add(TextEditingController());
                });
              },
              child: const Text("Ajouter une option"),
            ),
          ],

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(controller: answerController, decoration: const InputDecoration(hintText: "Entrez la réponse correcte")),
          ),

          ElevatedButton(
            onPressed: addQuestion,
            child: const Text("Ajouter Question"),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: questionsRef.orderBy("createdAt").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (snapshot.hasError) return Center(child: Text("Erreur: ${snapshot.error}"));
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Aucune question pour ce quiz.", textAlign: TextAlign.center));
                }

                var questions = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    var questionData = questions[index].data() as Map<String, dynamic>;
                    var questionId = questions[index].id;

                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(questionData['question']),
                        subtitle: questionData['isMultipleChoice'] == true
                          ? Text("Options: ${questionData['options'].join(', ')}\nRéponse: ${questionData['correctAnswer']}")
                          : Text("Réponse: ${questionData['correctAnswer']}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deleteQuestion(questionId);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
