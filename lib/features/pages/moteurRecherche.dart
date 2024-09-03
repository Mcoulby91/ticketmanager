import 'package:flutter/material.dart';

class Moteurrecherche extends StatefulWidget {
  const Moteurrecherche({super.key});

  @override
  State<Moteurrecherche> createState() => _MoteurrechercheState();
}

class _MoteurrechercheState extends State<Moteurrecherche> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Moteur de recherche",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
