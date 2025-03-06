import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'register_page.dart';
import 'package:quizz_game/components/components.dart';
import 'package:quizz_game/errors/error_utils.dart';

class PersonalInfoPage extends StatefulWidget {
  // Ajoute le paramètre onTap
  final Function()? onTap;

  const PersonalInfoPage({
    super.key,
    this.onTap, // Ce paramètre est optionnel, car on peut décider de ne pas l'utiliser
  });

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final residenceController = TextEditingController();
  final newBirthDateController = TextEditingController();

  // Fonction pour afficher le calendrier et formater la date
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(1900);  // Date minimale autorisée
    DateTime lastDate = DateTime.now();  // Date maximale autorisée (actuelle)

    // Afficher le calendrier et récupérer la date choisie
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    // Si une date est sélectionnée, formater et la mettre à jour dans le TextField
    if (selectedDate != null && selectedDate != initialDate) {
      setState(() {
        // Format de la date en "DD-MM-YYYY"
        newBirthDateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: const Text("Informations personnelles"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text("Prénom", style: TextStyle(fontSize: 16)),
              MyTextField(
                controller: firstNameController,
                hintText: "Prénom",
                obscureText: false,
              ),
              const SizedBox(height: 10),

              Text("Nom", style: TextStyle(fontSize: 16)),
              MyTextField(
                controller: lastNameController,
                hintText: "Nom de famille",
                obscureText: false,
              ),
              const SizedBox(height: 10),

              Text("Lieu de résidence", style: TextStyle(fontSize: 16)),
              MyTextField(
                controller: residenceController,
                hintText: "lieu de résidence",
                obscureText: false,
              ),
              const SizedBox(height: 10),

              Text("Date de nouvelle naissance en Christ", style: TextStyle(fontSize: 16)),
              GestureDetector(
                onTap: () => _selectDate(context),  // Appeler la fonction de sélection de date
                child: AbsorbPointer(
                  child: TextField(
                    controller: newBirthDateController,
                    decoration: InputDecoration(
                      hintText: "Choisir la date",
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80), // Laisse de la place pour le bouton
            ],
          ),
        ),
      ),

      // Bouton fixe en bas
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(vertical: 25),
        height: 75, // Limite la hauteur du bouton
        child: MyButton(
          onTap: () {
            // Vérifier que les champs ne sont pas vides
            if (firstNameController.text.trim().isEmpty ||
                lastNameController.text.trim().isEmpty ||
                residenceController.text.trim().isEmpty ||
                newBirthDateController.text.trim().isEmpty) {
              // Afficher un message d'erreur si un champ est vide
              showErrorMessage(context, "Veuillez remplir tous les champs.");
            } else {
              // Si tous les champs sont remplis, on passe à la page suivante
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterPage(
                    firstName: firstNameController.text.trim(),
                    lastName: lastNameController.text.trim(),
                    residence: residenceController.text.trim(),
                    newBirthDate: newBirthDateController.text.trim(),
                    onTap: () {}, // La fonction `onTap` vide ici
                  ),
                ),
              );
            }
          },
          text: "Continuer",
        ),
      ),
    );
  }
}
