import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars(); // Supprime les anciens SnackBars avant d'afficher un nouveau
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(25), // Ajoute un peu d'espace autour
      elevation: 6, // Ajoute une ombre pour un meilleur effet
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Arrondit les bords
      ),
    ),
  );
}
