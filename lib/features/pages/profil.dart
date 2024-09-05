import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:manager_ticket/features/pages/home_page.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String? userEmail;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    getCurrentUserEmail();
  }

  String formatDate(Timestamp timestamp) {
    DateTime dateTime =
        timestamp.toDate(); // Convertir le Timestamp en DateTime
    return DateFormat('dd/MM/yyyy').format(dateTime); // Formater la date
  }

  // Récupérer l'email de l'utilisateur courant
  Future<void> getCurrentUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        userEmail = user.email; // Récupération de l'email
      });
      await getUserDataFromFirestore(userEmail!);
    } else {
      setState(() {
        userEmail = "Aucun utilisateur connecté";
      });
    }
  }

  // Utiliser l'email pour récupérer les informations de l'utilisateur depuis Firestore
  Future<void> getUserDataFromFirestore(String email) async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('utilisateurs')
          .where('email', isEqualTo: email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        setState(() {
          userData = userSnapshot.docs[0].data() as Map<String, dynamic>;
        });
      } else {
        print('Aucun utilisateur trouvé avec cet email.');
      }
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Utilisateur'),
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator())
          : Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (userData!['imageUrl'] != null)
                        Center(
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.blue,
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              child: ClipOval(
                                child: Image.network(
                                  userData!['imageUrl'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      const Gap(15),
                      Text("Nom"),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: 650,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            const Gap(9),
                            /*Text(
                              "Nom :",
                              style: TextStyle(fontSize: 19, color: Colors.white),
                            ),
                            const Gap(5),*/
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${userData!['nom']}",
                                  style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Gap(5),
                      Text("Email"),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: 650,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.mail,
                              color: Colors.white,
                            ),
                            const Gap(9),
                            /*Text(
                              "Nom :",
                              style: TextStyle(fontSize: 19, color: Colors.white),
                            ),
                            const Gap(5),*/
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${userData!['email']}",
                                  style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Gap(5),
                      Text("Date de création"),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: 650,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.date_range,
                              color: Colors.white,
                            ),
                            const Gap(9),
                            /*Text(
                              "Nom :",
                              style: TextStyle(fontSize: 19, color: Colors.white),
                            ),
                            const Gap(5),*/
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${formatDate(userData!['dateCreation'])}",
                                  style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Gap(5),
                      Text("Rôle"),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: 650,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.admin_panel_settings,
                              color: Colors.white,
                            ),
                            const Gap(9),
                            /*Text(
                              "Nom :",
                              style: TextStyle(fontSize: 19, color: Colors.white),
                            ),
                            const Gap(5),*/
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${userData!['role']}",
                                  style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Affichage en fonction du rôle de l'utilisateur
                      if (userData!['role'] == 'Apprenant') ...[
                        const Gap(5),
                        Text("Formation"),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: 650,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.work,
                                color: Colors.white,
                              ),
                              const Gap(9),
                              /*Text(
                              "Nom :",
                              style: TextStyle(fontSize: 19, color: Colors.white),
                            ),
                            const Gap(5),*/
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${userData!['formation']}",
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Gap(5),
                        Text("Promotion"),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: 650,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: Colors.white,
                              ),
                              const Gap(9),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${userData!['promotion']}",
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ] else if (userData!['role'] == 'Formateur') ...[
                        const Gap(5),
                        Text("Domaine"),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: 650,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Icon(
                                Icons.work,
                                color: Colors.white,
                              ),
                              const Gap(9),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${userData!['domaine']}",
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ] else if (userData!['role'] == 'Admin') ...[
                        const Gap(5),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: 650,
                          height: 50,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Vous êtes Administrateur",
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                      const Gap(20),
                      Center(
                        child: Container(
                          width: 170,
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));
                              },
                              child: Text(
                                "Modifier",
                                style: GoogleFonts.poppins(color: Colors.white),
                              )),
                        ),
                      ),
                    ]),
              ),
            ),
    );
  }
}
