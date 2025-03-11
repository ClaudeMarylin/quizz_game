import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class QuizService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Récupérer les quiz de l'utilisateur
  Future<List<Map<String, dynamic>>> getQuizzesByUser() async {
    // Récupérer l'ID de l'utilisateur courant
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      throw Exception('Utilisateur non connecté');
    }

    try {
      // Interroger Firestore pour récupérer les quiz créés par cet utilisateur
      QuerySnapshot querySnapshot = await _firestore
          .collection('quizzes') // Assure-toi que la collection 'quizzes' existe
          .where('authorId', isEqualTo: userId) // Filtrer les quiz par userId
          .get();
          
      // Extraire les données des documents
      List<Map<String, dynamic>> quizzes = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return quizzes;
    } catch (e) {
      print('Erreur lors de la récupération des quiz: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getQuizzesFromOtherUsers() async {
    // Récupérer l'ID de l'utilisateur courant
    String userId = _auth.currentUser?.uid ?? '';
    if (userId.isEmpty) {
      throw Exception('Utilisateur non connecté');
    }

    try {
      // Interroger Firestore pour récupérer les quiz créés par d'autres utilisateurs
      QuerySnapshot querySnapshot = await _firestore
          .collection('quizzes')
          .where('authorId', isNotEqualTo: userId) // Exclure les quiz de l'utilisateur actuel
          .where('visibility', isEqualTo: 'Public') // Afficher uniquement les quiz publics
          .get();

      // Extraire les données des documents
      List<Map<String, dynamic>> quizzes = querySnapshot.docs
          .map((doc) => {
                "id": doc.id, // Inclure l'ID du document pour la navigation
                ...doc.data() as Map<String, dynamic>
              })
          .toList();
        
      return quizzes;
    } catch (e) {
      print('Erreur lors de la récupération des quiz des autres utilisateurs: $e');
      return [];
    }
  }

}
