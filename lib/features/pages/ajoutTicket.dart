import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MaterialApp(
    home: AjoutTicket(),
  ));
}

class AjoutTicket extends StatefulWidget {
  const AjoutTicket({super.key});

  @override
  State<AjoutTicket> createState() => _AjoutTicketState();
}

class _AjoutTicketState extends State<AjoutTicket> {
  String? selectedCategorie;
  String? titre;
  String? description;
  String? reponse = "Pas encore répondue";
  String? statut = "Attente";

  // Clé pour valider le formulaire
  final _formKey = GlobalKey<FormState>();

  // Envoyer les données dans Firebase
  Future<void> _soumettreForm() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> ticketData = {
        'titre': titre,
        'description': description,
        'statut': statut,
        'categorie': selectedCategorie,
        'dateCreation': Timestamp.now(),
        'reponse': reponse
      };

      try {
        await FirebaseFirestore.instance.collection('ticket').add(ticketData);
        ScaffoldMessenger.of(context).showSnackBar(
          AlertDialog(
            title: Text(
              "Soumission Ticket",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            content: Text(
              "Votre Ticket a été soumis avec succè et seras pris en charge le plutôt possible",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            elevation: 10,
            backgroundColor: Colors.blue,
          ) as SnackBar,
        );
        _formKey.currentState!.reset();
        setState(() {
          selectedCategorie = null;
          titre = description = null;
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
          "Ajouter un Ticket",
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
              Text(
                "Titre",
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
                    return 'Veuillez entrer le titre';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    titre = value;
                  });
                },
              ),
              SizedBox(height: 20),
              // Champ pour l'email
              Text(
                "Description",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                maxLines: null,
              ),
              SizedBox(height: 7.0),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la description';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
              ),
              SizedBox(height: 20),

              // DropdownButton pour sélectionner la catégorie
              Text(
                "Catégorie",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 7.0),
              DropdownButtonFormField<String>(
                value: selectedCategorie,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: ['Théorie', 'Pratique', 'Pédagogie']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategorie = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une catégorie';
                  }
                  return null;
                },
              ),
              //Button pour créer
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _soumettreForm(); // Appeler la soumission
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Ajouter',
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
