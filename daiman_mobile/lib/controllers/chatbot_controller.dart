import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ChatbotController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> submitReport(String reportContent) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in.");
      }

      final userID = user.uid;
      final now = DateTime.now();

      final docRef = _firestore.collection('query').doc();

      await docRef.set({
        'queryID': docRef.id,
        'userID': userID,
        'date': now,
        'report': reportContent,
        'status': 'pending', 
      });

    } catch (e) {
      rethrow;
    }
  }
}
