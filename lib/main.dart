import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizz_game/pages/auth_page.dart';
import 'package:quizz_game/pages/home_page.dart';
import 'package:quizz_game/pages/login_page.dart';
import 'package:quizz_game/quiz/create_quiz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quizz_game/quiz/display_all_quizzes.dart';
import 'package:quizz_game/quiz/my_quiz_page.dart';
import 'package:quizz_game/quiz/solve_quiz_page.dart';
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
          case '/login':
            return MaterialPageRoute(builder: (context) => LoginPage(
              onTap: (){},
            ));
          case '/home':
            return MaterialPageRoute(builder: (context) => HomePage());
          case '/create_quiz':
            return MaterialPageRoute(builder: (context) => CreateQuiz());
          case '/my_quiz':
            return MaterialPageRoute(builder: (context) => MyQuizPage());
          case '/display_all_quizzes':
            return MaterialPageRoute(builder: (context) => DisplayAllQuizzes());
          case '/solve_quiz':
            return MaterialPageRoute(
              builder: (context) => SolveQuizPage(quizId: settings.arguments as String),
            );
          default:
            return null;
        }
      },
    );
  }
}

