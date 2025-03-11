import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;

  const MyAppBar({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      centerTitle: true,
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      leading: FirebaseAuth.instance.currentUser != null 
        ? IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Ouvre le Drawer
            },
          )
        : null, // Cache le bouton si l'utilisateur n'est pas connecté
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
