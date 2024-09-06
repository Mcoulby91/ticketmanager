import 'package:flutter/material.dart';

class HomePageFormateur extends StatefulWidget {
  const HomePageFormateur({super.key});

  @override
  State<HomePageFormateur> createState() => _HomePageFormateurState();
}

class _HomePageFormateurState extends State<HomePageFormateur> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [Text("Bienvenue")],
      ),
    );
  }
}
