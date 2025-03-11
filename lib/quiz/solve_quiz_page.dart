import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SolveQuizPage extends StatefulWidget {
  final String quizId;

  const SolveQuizPage({super.key, required this.quizId});

  @override
  _SolveQuizPageState createState() => _SolveQuizPageState();
}

class _SolveQuizPageState extends State<SolveQuizPage> {
  List<Map<String, dynamic>> questions = [];
  Map<String, dynamic> userAnswers = {};
  bool quizSubmitted = false;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection("quizzes")
        .doc(widget.quizId)
        .collection("questions")
        .orderBy("createdAt")
        .get();

    setState(() {
      questions = querySnapshot.docs
          .map((doc) => {"id": doc.id, ...doc.data()})
          .toList();
    });
  }

  void submitQuiz() {
    setState(() {
      quizSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Résoudre le Quiz")),
      body: questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                var question = questions[index];
                bool isMultipleChoice = question['isMultipleChoice'] ?? false;
                String questionId = question['id'];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Q${index + 1}: ${question['question']}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        
                        if (isMultipleChoice) ...[
                          Column(
                            children: (question['options'] as List<dynamic>)
                                .map<Widget>((option) {
                              return RadioListTile(
                                title: Text(option),
                                value: option,
                                groupValue: userAnswers[questionId],
                                onChanged: (value) {
                                  setState(() {
                                    userAnswers[questionId] = value;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ] else ...[
                          TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Votre réponse",
                            ),
                            onChanged: (value) {
                              userAnswers[questionId] = value;
                            },
                          ),
                        ],

                        if (quizSubmitted)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "Réponse correcte : ${question['correctAnswer']}",
                              style: TextStyle(
                                color: userAnswers[questionId] == question['correctAnswer'] ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: submitQuiz,
        label: const Text("Valider"),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
