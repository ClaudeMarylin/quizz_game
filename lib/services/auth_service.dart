import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Connexion avec Google (inscription ou login)
  Future<UserCredential?> signInWithGoogle({
    String? firstName,
    String? lastName,
    String? residence,
    String? newBirthDate,
  }) async {
    try {
      // Lancer l'authentification avec Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // L'utilisateur a annulé l'auth

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Connexion Firebase
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // Vérifier si l'utilisateur existe déjà dans Firestore
        DocumentSnapshot userDoc = await _firestore.collection("users").doc(user.uid).get();

        if (!userDoc.exists && firstName != null && lastName != null && residence != null && newBirthDate != null) {
          // Ajouter l'utilisateur à Firestore (uniquement si c'est une inscription)
          await _firestore.collection("users").doc(user.uid).set({
            "uid": user.uid,
            "email": user.email,
            "displayName": user.displayName ?? "$firstName $lastName",
            "photoURL": user.photoURL,
            "firstName": firstName,
            "lastName": lastName,
            "residence": residence,
            "newBirthDate": newBirthDate,
            "createdAt": FieldValue.serverTimestamp(),
          });
        }
      }

      return userCredential;
    } catch (e) {
      print("Erreur Google Sign-In: $e");
      return null;
    }
  }
}
