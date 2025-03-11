import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:quizz_game/theme/theme_provider.dart';
import 'package:quizz_game/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void signUserOut(BuildContext context) {
    FirebaseAuth.instance.signOut().then((_) {
      Navigator.pushReplacementNamed(context, "/login");
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeData.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
            ),
            child: const SizedBox(
              height: 100,
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          MyListTile(
            icon: const Icon(Icons.home),
            text: "Accueil",
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          MyListTile(
            icon: const Icon(Icons.person),
            text: "Profil",
            onTap: () {},
          ),
          MyListTile(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            text: isDarkMode ? 'Mode clair' : 'Mode sombre',
            onTap: () {
              themeProvider.toggleTheme();
            },
          ),
          MyListTile(
            icon: const Icon(Icons.logout, color: Colors.red),
            text: "Déconnexion",
            onTap: () => signUserOut(context), // Passer le contexte ici
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
