import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizz_game/components/components.dart';
import 'package:quizz_game/errors/error_utils.dart';

class CreateQuiz extends StatefulWidget {
  const CreateQuiz({super.key});

  @override
  _CreateQuizState createState() => _CreateQuizState();
}

class _CreateQuizState extends State<CreateQuiz> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final otherCategoryController = TextEditingController();

  String? selectedCategory;
  String? selectedDifficulty;
  String? selectedVisibility;

  final List<String> categories = [
    "Histoire",
    "Science",
    "Cinéma",
    "Géographie",
    "Autre"
  ];
  final List<String> difficulties = ["Facile", "Moyen", "Difficile"];
  final List<String> visibilities = ["Public", "Privé"];

  void createQuiz() async {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        selectedCategory == null ||
        selectedDifficulty == null ||
        selectedVisibility == null ||
        (selectedCategory == "Autre" && otherCategoryController.text.trim().isEmpty)) {
      showErrorMessage(context, "Veuillez remplir tous les champs.");
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      showErrorMessage(context, "Vous devez être connecté pour créer un quiz.");
      return;
    }

    // Affichage du chargement
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseFirestore.instance.collection("quizzes").add({
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "category": selectedCategory == "Autre"
            ? otherCategoryController.text.trim()
            : selectedCategory,
        "difficulty": selectedDifficulty,
        "visibility": selectedVisibility,
        "authorId": user.uid,
        "createdAt": Timestamp.now(),
      });

      Navigator.pop(context); // Fermer le chargement
      Navigator.pop(context); // Retourner à la page précédente
    } catch (e) {
      Navigator.pop(context); // Fermer le chargement
      showErrorMessage(context, "Erreur lors de la création du quiz.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: MyAppBar(
        text: "Création Quiz",
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text("Titre du quiz", style: TextStyle(fontSize: 16)),
              MyTextField(
                controller: titleController,
                hintText: "Entrez le titre du quiz",
                obscureText: false,
              ),
              const SizedBox(height: 10),

              const Text("Description du quiz", style: TextStyle(fontSize: 16)),
              MyTextField(
                controller: descriptionController,
                hintText: "Entrez une description",
                obscureText: false,
              ),
              const SizedBox(height: 10),

              // Sélection de la catégorie
              const Text("Catégorie", style: TextStyle(fontSize: 16)),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Choisissez une catégorie",
                ),
              ),
              if (selectedCategory == "Autre") ...[
                const SizedBox(height: 10),
                MyTextField(
                  controller: otherCategoryController,
                  hintText: "Entrez votre propre catégorie",
                  obscureText: false,
                ),
              ],
              const SizedBox(height: 10),

              // Sélection de la difficulté
              const Text("Difficulté", style: TextStyle(fontSize: 16)),
              DropdownButtonFormField<String>(
                value: selectedDifficulty,
                items: difficulties.map((String difficulty) {
                  return DropdownMenuItem(
                    value: difficulty,
                    child: Text(difficulty),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDifficulty = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Choisissez une difficulté",
                ),
              ),
              const SizedBox(height: 10),

              // Sélection de la visibilité
              const Text("Visibilité", style: TextStyle(fontSize: 16)),
              DropdownButtonFormField<String>(
                value: selectedVisibility,
                items: visibilities.map((String visibility) {
                  return DropdownMenuItem(
                    value: visibility,
                    child: Text(visibility),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedVisibility = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Choisissez une visibilité",
                ),
              ),
            ],
          ),
        ),
      ),

      // Bouton de validation
      bottomNavigationBar: BottomAppBar(
        color: Colors.red[300], // Couleur de fond
        child: Container(
          height: 60, // Hauteur du BottomAppBar
          padding: const EdgeInsets.symmetric(horizontal: 2), // Espacement horizontal
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espacement équilibré
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  // Action pour la page d'accueil
                  Navigator.pushReplacementNamed(context, '/home');
                },
              ),
              Expanded( // Permet au bouton d'occuper l'espace central
                child: MyButton(
                  onTap: createQuiz,
                  text: "Créer le quiz",
                ),
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white),
                onPressed: () {
                  // Action pour la page profil
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
