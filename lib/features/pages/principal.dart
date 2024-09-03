import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manager_ticket/features/pages/ajoutTicket.dart';
import 'package:manager_ticket/features/pages/chat.dart';
import 'package:manager_ticket/features/pages/home_page.dart';
import 'package:manager_ticket/features/pages/profil.dart';

import '../styles/drawerPersonnaliser.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[HomePage(), Chat()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: CustomDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AjoutTicket()));
        },
        child: Icon(FluentSystemIcons.ic_fluent_ticket_regular),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      appBar: AppBar(
        title: Text(
          "Ticket Manager",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        titleSpacing: 5,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications),
            color: Colors.white,
          ),
          Container(
            width: 50,
            height: 50,
            decoration:
                BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Profil()),
                );
              },
              icon: Icon(Icons.person),
              color: Colors.grey,
            ),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          onTap: _onItemTapped,
          currentIndex: _selectedIndex,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Colors.blue,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: const Color(0xFF526480),
          items: [
            BottomNavigationBarItem(
                icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
                activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
                label: "Acceuil"),
            BottomNavigationBarItem(
                icon: Icon(FluentSystemIcons.ic_fluent_chat_regular),
                activeIcon: Icon(FluentSystemIcons.ic_fluent_chat_filled),
                label: "Chat"),
          ]),
    );
  }
}
