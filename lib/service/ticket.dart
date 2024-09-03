import 'package:cloud_firestore/cloud_firestore.dart';

class TicketService {
  // get collections of tickets
  final CollectionReference tickets =
      FirebaseFirestore.instance.collection('tickets');

  // CREATE : ajouter un ticket
  Future addTicket(Map<String, dynamic> ticketInfoMap) async {}
  // READ : lire ticket

  // UPDATE : modifier ticket

  // DELETE : supprimer ticket
}
