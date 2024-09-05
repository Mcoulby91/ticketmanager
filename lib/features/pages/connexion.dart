import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manager_ticket/features/pages/connexion.dart';
import 'package:manager_ticket/features/pages/principal.dart';
import 'package:manager_ticket/features/pages/principalApprenant.dart';
import 'package:manager_ticket/features/pages/principalFormateur.dart';
import 'package:manager_ticket/features/styles/delayAnimation.dart';

// Import statements ...

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  var _obscureText = true;
  String email = "", password = "";
  final _formKey = GlobalKey<FormState>();
  TextEditingController userEmailControlleur = TextEditingController();
  TextEditingController userPasswordControlleur = TextEditingController();
  //----------------------------------------------------------------
  void userLogin() async {
    final email = userEmailControlleur.text.trim();
    final password = userEmailControlleur.text.trim();

    try {
      // Connexion de l'utilisateur avec Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Récupérer le rôle de l'utilisateur dans Firestore
      String userId = userCredential.user?.uid ?? '';
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        String role = userDoc.get('role');
        if (role == 'Apprenant') {
          // Rediriger l'utilisateur vers le Dashbord_apprenant
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PrincipalApprenant()),
          );
        } else if ((role == 'Formateur')) {
          // Rediriger l'utilisateur vers un autre dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PrincipalFormateur()),
          );
        } else {
          // Rediriger l'utilisateur vers un autre dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Principal()),
          );
        }
      } else {
        // Gestion du cas où l'utilisateur n'existe pas dans Firestore
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Erreur lors de la récupération des informations utilisateur.'),
          ),
        );
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        // Gestion des erreurs Firebase spécifiques
        print('Erreur de connexion Firebase: ${e.code}');
        String errorMessage =
            'Une erreur est survenue lors de la connexion. Veuillez réessayer.';
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'L\'adresse email est invalide.';
            break;
          case 'wrong-password':
            errorMessage = 'Le mot de passe est incorrect.';
            break;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );
      } else {
        // Gestion des autres types d'erreurs
        print('Erreur de connexion: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Une erreur est survenue lors de la connexion. Merci de réessayer.'),
          ),
        );
      }
    }
  }

  //------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: Colors.black,
                size: 30,
              )),
        ),
        backgroundColor: Colors.white, // Définit la couleur de fond à blanc
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(children: [
            Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  DelayedAnimation(
                      delay: 200,
                      child: Container(
                        height: 280,
                        child: Image.asset('assets/icons/Login.png'),
                      )),
                ])),
            SizedBox(height: 35),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  DelayedAnimation(
                    delay: 400,
                    child: TextFormField(
                      controller: userEmailControlleur,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "S'il vous plaît entrez votre Email";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Your Email',
                        labelStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  DelayedAnimation(
                    delay: 600,
                    child: TextFormField(
                      controller: userPasswordControlleur,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "S'il vous plaît entrez votre Mot de passe";
                        }
                        return null;
                      },
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Colors.grey[400],
                        ),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  DelayedAnimation(
                      delay: 800,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 30,
                          horizontal: 40,
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      email = userEmailControlleur.text;
                                      password = userPasswordControlleur.text;
                                    });
                                    userLogin();
                                  }
                                },
                                child: Center(
                                    child: Container(
                                  width: 200,
                                  height: 55,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Connexion",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )))
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ]),
        )));
  }
}
