import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizz_game/pages/auth_page.dart';
import 'package:quizz_game/pages/home_page.dart';
import 'package:quizz_game/quiz/create_quiz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quizz_game/theme/theme_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child : const MainApp()
    )
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(builder: (context) => HomePage());
          case '/create_quiz':
            return MaterialPageRoute(builder: (context) => CreateQuiz());
          default:
            return null;
        }
      },
    );
  }
}

