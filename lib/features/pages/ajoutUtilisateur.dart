import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MaterialApp(
    home: AjoutUtilisateur(),
  ));
}

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

  // Fonction pour sélectionner une image de la galerie
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<String?> _uploadImage(XFile image) async {
    try {
      // Créer une référence de stockage pour l'image
      final storageRef = FirebaseStorage.instance.ref().child(
          'user_images/${DateTime.now().millisecondsSinceEpoch}_${image.name}');

      // Télécharger l'image vers Firebase Storage
      final uploadTask = storageRef.putFile(File(image.path));

      // Attendre la fin du téléchargement et obtenir l'URL de l'image
      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Erreur lors du téléchargement de l\'image: $e');
      return null;
    }
  }

  // Clé pour valider le formulaire
  final _formKey = GlobalKey<FormState>();

  // vérifier si l'utilisateur exist
  Future<bool> _userExists(String email) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('utilisateurs')
        .where('email', isEqualTo: email)
        .get();
    return result.docs.isNotEmpty;
  }

// envoyer les données dans firebase
  Future<void> _soumettreForm() async {
    if (_formKey.currentState!.validate()) {
      if (await _userExists(email!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Un utilisateur avec cet email existe déjà.')),
        );
        return;
      }
      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImage(_imageFile!);
      }
      // Créer l'utilisateur avec Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: motDePasse!);

      Map<String, dynamic> userData = {
        'nom': nom,
        'email': email,
        'motDePasse': motDePasse,
        'role': selectedRole,
        'dateCreation': Timestamp.now(), // Date de création
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (selectedRole == 'Apprenant') ...{
          'promotion': promotion,
          'formation': formation,
        } else if (selectedRole == 'Formateur') ...{
          'domaine': domaine,
        },
      };

      try {
        await FirebaseFirestore.instance
            .collection('utilisateurs')
            .add(userData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Utilisateur créé avec succès!')),
        );
        // Réinitialiser les champs aprés création
        _formKey.currentState!.reset();
        setState(() {
          _imageFile = null;
          selectedRole = null;
          nom = email = motDePasse = promotion = formation = domaine = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Erreur lors de la création de l\'utilisateur: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              // Champ pour l'insertion de la photo de profil
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
              // Champ pour le nom
              Text(
                "Nom",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 7.0),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    nom = value;
                  });
                },
              ),
              SizedBox(height: 20),
              // Champ pour l'email
              Text(
                "Email",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 7.0),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer l\'email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              SizedBox(height: 20),
              // Champ pour le mot de passe
              Text(
                "Mot de passe",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 7.0),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le mot de passe';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    motDePasse = value;
                  });
                },
              ),
              SizedBox(height: 20),
              // DropdownButton pour sélectionner le rôle
              Text(
                "Rôle",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 7.0),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: ['Apprenant', 'Formateur', 'Admin']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRole = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner un rôle';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Champs supplémentaires en fonction du rôle sélectionné
              if (selectedRole == 'Apprenant') ...[
                Text(
                  "Formation",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 7.0),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer la formation';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      formation = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "Promotion",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 7.0),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer la promotion';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      promotion = value;
                    });
                  },
                ),
              ] else if (selectedRole == 'Formateur') ...[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Domaine",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le domaine';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      domaine = value;
                    });
                  },
                ),
              ],
              SizedBox(height: 30),
              // Bouton Créer
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _soumettreForm();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Créer',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
