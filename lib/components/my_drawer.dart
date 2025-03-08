import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // Enlève le padding par défaut
        children: [
          // Ajoute un Header dans le Drawer
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red[300], // Utilisation de red[300]
            ),
            child: const SizedBox(
              height: 100, // Remplace cette valeur par la hauteur souhaitée
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home), 
            title: Text('Accueil')
          ),
          ListTile(
            leading: Icon(Icons.person), 
            title: Text('Profil')
          ),
          // Exemple d'item dans le Drawer
          ListTile(
            title: const Text('Page 1'),
            onTap: () {
              // Rediriger vers une page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Page1()),
              );
            },
          ),
          ListTile(
            title: const Text('Page 2'),
            onTap: () {
              // Rediriger vers une autre page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Page2()),
              );
            },
          ),
          ListTile(
            title: const Text('Page 3'),
            onTap: () {
              // Rediriger vers une autre page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Page2()),
              );
            },
          ),
          // Ajouter d'autres éléments comme tu le souhaites

          const Spacer(), // Pousse l'élément suivant en bas

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Déconnexion'),
            onTap: () {
              // Ajoute ici l'action de déconnexion
            },
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 1')),
      body: const Center(child: Text('Contenu de la Page 1')),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 2')),
      body: const Center(child: Text('Contenu de la Page 2')),
    );
  }
}
