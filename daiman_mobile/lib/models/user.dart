import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userID;
  final String email;
  final String username;

  UserModel({
    required this.userID,
    required this.email,
    required this.username,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserModel(
      userID: doc.id,
      email: data['email'],
      username: data['username'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
    };
  }
}
