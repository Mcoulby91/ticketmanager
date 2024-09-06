import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:manager_ticket/features/pages/ajoutUtilisateur.dart';

class Utilisateur extends StatefulWidget {
  const Utilisateur({super.key});

  @override
  State<Utilisateur> createState() => _UtilisateurState();
}

class _UtilisateurState extends State<Utilisateur> {
  late User? _currentUser;
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
  void initState() {
    super.initState();
    _currentUser =
        FirebaseAuth.instance.currentUser; // Obtenir l'utilisateur courant
  }

  // Méthode pour afficher une boîte de dialogue de confirmation avant suppression
  void _confirmDelete(
      BuildContext context, String userId, String email, String imageUrl) {
    // Vérifier si l'utilisateur à supprimer est l'utilisateur courant par email
    if (_currentUser != null && _currentUser!.email == email) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Vous ne pouvez pas supprimer l'utilisateur courant.")),
      );
      return; // Ne pas poursuivre l'opération de suppression
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content:
              const Text("Voulez-vous vraiment supprimer cet utilisateur ?"),
          actions: [
            TextButton(
              child: const Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Supprimer"),
              onPressed: () async {
                Navigator.of(context).pop(); // Fermer le dialogue

                try {
                  // Suppression de l'utilisateur dans Firebase Auth
                  await _deleteUserFromAuth(email);

                  // Suppression de l'utilisateur dans Firestore
                  await FirebaseFirestore.instance
                      .collection('utilisateurs')
                      .doc(userId)
                      .delete();

                  // Suppression de l'image de l'utilisateur dans Firebase Storage
                  if (imageUrl.isNotEmpty) {
                    await FirebaseStorage.instance
                        .refFromURL(imageUrl)
                        .delete();
                  }
                } catch (e) {
                  print("Erreur lors de la suppression : $e");
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Méthode pour supprimer un utilisateur dans Firebase Authentication
  Future<void> _deleteUserFromAuth(String email) async {
    try {
      List<User> users = FirebaseAuth.instance.currentUser != null
          ? [FirebaseAuth.instance.currentUser!]
          : [];
      for (var user in users) {
        if (user.email == email) {
          await user.delete();
          break;
        }
      }
    } catch (e) {
      print(
          "Erreur lors de la suppression de l'utilisateur dans Firebase Auth : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Utilisateurs",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AjoutUtilisateur()));
        },
        child: const Icon(FluentSystemIcons.ic_fluent_add_regular),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Rechercher un utilisateur",
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                    selectedRole = 'Admin';
                  } else if (index == 2) {
                    selectedRole = 'Formateur';
                  } else {
                    selectedRole = 'Apprenant';
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
                  child: Text("Admin"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text("Formateur"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text("Apprenant"),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('utilisateurs')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Filtrer les utilisateurs en fonction de la recherche et du rôle sélectionné
                final users = snapshot.data!.docs.where((user) {
                  var nom = user['nom'].toString().toLowerCase();
                  var role = user['role'].toString();

                  // Afficher tous les utilisateurs si "Tous" est sélectionné, sinon filtrer par rôle
                  return nom.contains(searchQuery) &&
                      (selectedRole.isEmpty || role == selectedRole);
                }).toList();

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];
                    String userId = user.id;
                    String role = user['role'];
                    String email = user['email'];
                    String imageUrl = user['imageUrl'];
                    String dateCreation = (user['dateCreation'] as Timestamp)
                        .toDate()
                        .toString()
                        .split(' ')[0];

                    String additionalInfo = '';
                    if (role == 'Apprenant') {
                      additionalInfo =
                          'Formation: ${user['formation']}\nPromotion: ${user['promotion']}';
                    } else if (role == 'Formateur') {
                      additionalInfo = 'Domaine: ${user['domaine']}';
                    }

                    bool isCurrentUser =
                        _currentUser != null && _currentUser!.email == email;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(user['nom']),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Email: ${user['email']}"),
                                      Text("Rôle: $role"),
                                      Text("Date de création: $dateCreation"),
                                      if (additionalInfo.isNotEmpty)
                                        Text(additionalInfo),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text("Fermer"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    if (!isCurrentUser)
                                      TextButton(
                                        child: const Text("Supprimer"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          _confirmDelete(
                                              context, userId, email, imageUrl);
                                        },
                                      ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(left: 7.0),
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(imageUrl),
                                  ),
                                ),
                                const Gap(10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user['nom'],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    const Gap(14),
                                    Row(
                                      children: [
                                        const Text(
                                          "Rôle :",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                        const Gap(7),
                                        Text(
                                          role,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
