import 'package:flutter/material.dart';

class Historiqueticket extends StatefulWidget {
  const Historiqueticket({super.key});

  @override
  State<Historiqueticket> createState() => _HistoriqueticketState();
}

class _HistoriqueticketState extends State<Historiqueticket> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Historique Tickets",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
