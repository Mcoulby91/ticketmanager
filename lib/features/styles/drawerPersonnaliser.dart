import 'package:flutter/material.dart';
import 'package:manager_ticket/features/pages/bienvenue.dart';
import 'package:manager_ticket/features/pages/categorie.dart';
import 'package:manager_ticket/features/pages/historiqueTicket.dart';
import 'package:manager_ticket/features/pages/moteurRecherche.dart';
import 'package:manager_ticket/features/pages/utilisateur.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            leading: Icon(Icons.person),
            title: Text('Utilisateurs'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Utilisateur()));
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Moteur de Recherche'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Moteurrecherche()));
            },
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
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Catégorie'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Categorie()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Déconnexion'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Bienvenue()));
            },
          ),
        ],
      ),
    );
  }
}
