import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:manager_ticket/firebase_options.dart';
import 'features/pages/bienvenue.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Vérifie si Firebase a déjà été initialisé
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Bienvenue(),
    );
  }
}
