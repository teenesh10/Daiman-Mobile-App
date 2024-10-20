// auth_controller.dart
import 'package:daiman_mobile/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Login with email and password
  Future<String?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Save user data in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('userID', userCredential.user!.uid);
      prefs.setString('userEmail', email); // Save user email
      prefs.setString('userPassword', password); // Save user password

      return null; // Success
    } catch (e) {
      return e.toString(); // Return error
    }
  }

  // Register a new user
  Future<String?> register(
      String username, String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Add user to Firestore
      UserModel newUser = UserModel(
        userID: userCredential.user!.uid,
        email: email,
        username: username,
      );
      await _firestore
          .collection('user')
          .doc(newUser.userID)
          .set(newUser.toFirestore());

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      return null; // Success
    } catch (e) {
      return e.toString(); // Return error
    }
  }

  // Forgot password
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // Success
    } catch (e) {
      return e.toString(); // Return error
    }
  }

  // Logout method
  Future<void> logout() async {
    await _auth.signOut(); // Sign out from Firebase

    // Clear user data in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn');
    prefs.remove('userID');
    prefs.remove('userEmail');
    prefs.remove('userPassword');
  }
}
