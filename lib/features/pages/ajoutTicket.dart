import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      // Obtenir l'utilisateur courant
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Récupérer l'email de l'utilisateur courant
        String? email = user.email;

        Map<String, dynamic> ticketData = {
          'titre': titre,
          'description': description,
          'statut': statut,
          'categorie': selectedCategorie,
          'dateCreation': Timestamp.now(),
          'reponse': reponse,
          'email': email,
        };

        try {
          await FirebaseFirestore.instance.collection('ticket').add(ticketData);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.blue,
              title: Text(
                "Soumission Ticket",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              content: Text(
                "Votre Ticket a été soumis avec succès et sera pris en charge le plus tôt possible.",
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

          _formKey.currentState!.reset();
          setState(() {
            selectedCategorie = null;
            titre = description = null;
          });
        } catch (e) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.red,
              title: Text(
                "Soumission Ticket",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              content: Text(
                "Votre Ticket n'a pas été soumis, une erreur est surnenue lors de l'envoie. : $e",
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
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.red,
            title: Text(
              "Soumission Ticket",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            content: Text(
              "Utilisateur non authentifier",
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
              Text(
                "Description",
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
                keyboardType: TextInputType.multiline,
                maxLines: null,
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
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  _soumettreForm();
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
