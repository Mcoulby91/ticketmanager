import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UserService {
  // Vérifie si l'utilisateur existe déjà dans Firestore
  Future<bool> userExists(String email) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('utilisateurs')
        .where('email', isEqualTo: email)
        .get();
    return result.docs.isNotEmpty;
  }

  // Crée un utilisateur dans Firebase Authentication et Firestore
  Future<void> createUser(
      Map<String, dynamic> userData, String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    await FirebaseFirestore.instance.collection('utilisateurs').add(userData);
  }

  // Télécharge une image dans Firebase Storage et retourne l'URL
  Future<String?> uploadImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
          'user_images/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Erreur lors du téléchargement de l\'image: $e');
      return null;
    }
  }
}
