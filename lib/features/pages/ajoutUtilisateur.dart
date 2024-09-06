import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:manager_ticket/features/model/userModel.dart';
import 'package:manager_ticket/features/model/meyhodeValidation.dart';
import 'package:manager_ticket/features/service/userService.dart';

class AjoutUtilisateur extends StatefulWidget {
  const AjoutUtilisateur({super.key});

  @override
  State<AjoutUtilisateur> createState() => _AjoutUtilisateurState();
}

class _AjoutUtilisateurState extends State<AjoutUtilisateur> {
  String? selectedRole;
  String? promotion;
  String? formation;
  String? domaine;
  String? nom;
  String? email;
  String? motDePasse;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _imageError;

  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService(); // Initialisation du service

  // Fonction pour sélectionner une image de la galerie
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  // Soumission du formulaire
  Future<void> _soumettreForm() async {
    setState(() {
      _imageError = FormValidator.validateImage(_imageFile);
    });

    if (_formKey.currentState!.validate() && _imageError == null) {
      if (await _userService.userExists(email!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Un utilisateur avec cet email existe déjà.')),
        );
        return;
      }

      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _userService.uploadImage(File(_imageFile!.path));
      }

      Map<String, dynamic> userData = {
        'nom': nom,
        'email': email,
        'role': selectedRole,
        'dateCreation': Timestamp.now(),
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (selectedRole == 'Apprenant') ...{
          'promotion': promotion,
          'formation': formation,
        } else if (selectedRole == 'Formateur') ...{
          'domaine': domaine,
        },
      };

      try {
        await _userService.createUser(userData, email!, motDePasse!);
        _showSuccessDialog();
        _resetForm();
      } catch (e) {
        _showErrorDialog(e);
      }
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _imageFile = null;
      selectedRole = null;
      nom = email = motDePasse = promotion = formation = domaine = null;
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue,
        title: Text(
          "Création Utilisateur",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        content: Text(
          "Le nouveau utilisateur a été créé avec succès !",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(Object e) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red,
        title: Text(
          "Création Utilisateur",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        content: Text(
          "Erreur: $e",
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Le code de la vue reste inchangé avec la logique déplacée dans les services et la validation
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Ajouter un Utilisateur",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue,
                  child: _imageFile != null
                      ? ClipOval(
                          child: Image.file(
                            File(_imageFile!.path),
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        )
                      : Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 50,
                        ),
                ),
              ),
              if (_imageError != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _imageError!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ElevatedButton(
                onPressed: _soumettreForm,
                child: Text('Créer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
