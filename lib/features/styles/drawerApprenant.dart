import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:manager_ticket/features/pages/bienvenue.dart';
import 'package:manager_ticket/features/pages/connexion.dart';
import 'package:manager_ticket/features/pages/historiqueTicket.dart';
import 'package:manager_ticket/features/pages/utilisateur.dart';

class CustomDrawerApprenant extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> _logout() async {
      try {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Connexion()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur lors de la déconnexion: ${e.toString()}"),
          ),
        );
      }
    }

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/header_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset(
                    'assets/icons/Logo.png',
                    height: 120,
                    width: 120,
                  ),
                )
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.archive),
            title: Text('Historique Tickets'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Historiqueticket()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Déconnexion'),
            onTap: () {
              _logout();
            },
          ),
        ],
      ),
    );
  }
}
