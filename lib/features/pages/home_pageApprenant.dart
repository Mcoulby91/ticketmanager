import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageapprenant extends StatefulWidget {
  const HomePageapprenant({super.key});

  @override
  State<HomePageapprenant> createState() => _HomePageapprenantState();
}

class _HomePageapprenantState extends State<HomePageapprenant> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  List<bool> _isSelected = [
    true,
    false,
    false,
    false
  ]; // Tous, Admin, Formateur, Apprenant
  String selectedRole = ''; // Vide pour "Tous", sinon rôle sélectionné

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un Ticket",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    setState(() {
                      searchQuery = "";
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query.toLowerCase();
                });
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Tickets réscents",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text("Affichage des tickets réscents"),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Mes Tickets",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                      fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: ToggleButtons(
              isSelected: _isSelected,
              borderRadius: BorderRadius.circular(10),
              selectedColor: Colors.white,
              fillColor: Colors.blue,
              color: Colors.grey,
              selectedBorderColor: Colors.blue,
              borderColor: Colors.grey,
              borderWidth: 2,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < _isSelected.length; i++) {
                    _isSelected[i] = i == index;
                  }
                  // Met à jour le rôle sélectionné
                  if (index == 0) {
                    selectedRole = ''; // Pas de filtrage pour "Tous"
                  } else if (index == 1) {
                    selectedRole = 'Théorie';
                  } else if (index == 2) {
                    selectedRole = 'Pratique';
                  } else {
                    selectedRole = 'Pédagogie';
                  }
                });
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text("Tous"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text("Théorie"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text("Pratique"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text("Pédagogie"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
