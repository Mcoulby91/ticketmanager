import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AjoutTicket extends StatefulWidget {
  const AjoutTicket({super.key});

  @override
  State<AjoutTicket> createState() => _AjoutTicketState();
}

class _AjoutTicketState extends State<AjoutTicket> {
  TextEditingController titrecontrolleur = new TextEditingController();
  TextEditingController descriptioncontrolleur = new TextEditingController();
  // Valeur sélectionnée initialement
  String? dropdownValue;

  // Liste des options du Dropdown
  final List<String> options = ['Technique', 'Pratique', 'Théorie'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Ajouet un ticket",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        margin: EdgeInsets.only(left: 20.0, top: 18.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Titre",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 7.0),
            Container(
              padding: EdgeInsets.only(left: 7),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            const Gap(16),
            Text(
              "Description",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 7.0),
            Container(
              padding: EdgeInsets.only(left: 7),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            const Gap(16),
            Text(
              "Catégorie",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 7.0),
            Container(
                padding: EdgeInsets.only(left: 7),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  hint: Text('Sélectionnez un catégorie'),
                  icon: Icon(Icons.arrow_downward),
                  style: TextStyle(color: Colors.black),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ))
          ],
        ),
      ),
    );
  }
}
