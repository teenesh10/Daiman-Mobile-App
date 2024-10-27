// auth_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Login with email and password
  Future<String?> login(String email, String password) async {
    try {
      // Attempt to sign in the user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Reload user data to check verification status
      await userCredential.user!.reload();
      User? user = _auth.currentUser; // Get the current user

      // Check if email is verified
      if (!user!.emailVerified) {
        await _auth.signOut(); // Sign out the user if email is not verified
        return "Please verify your email.";
      }

      // Save login status to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', email);
      await prefs.setString('userPassword', password);

      return "Login successful"; // Login successful
    } on FirebaseAuthException catch (e) {
      return e.message; // Return any errors that occurred from Firebase
    } catch (e) {
      return "An unexpected error occurred."; // General error message
    }
  }

  // Register a new user
  Future<String?> register(
      String username, String email, String password) async {
    try {
      // Attempt to create a new user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      // Save user data to Firestore with verification flag set to false
      await _firestore.collection('user').doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
      });

      // Return success message here
      return "Verification link sent to your email.";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "This email already exists."; // Email exists
      }
      return e.message; // Return other errors
    } catch (e) {
      return e.toString(); // Return general errors
    }
  }

// Call this method after the user verifies their email
  Future<void> updateEmailVerificationStatus(String uid) async {
    await _firestore.collection('user').doc(uid).update({'isVerified': true});
  }

  // Forgot password
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "success"; // Indicate success explicitly
    } catch (e) {
      // Handle Firebase-specific error messages
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'invalid-email':
            return "The email address is not valid.";
          case 'user-not-found':
            return "No user found with this email.";
          default:
            return "An error occurred. Please try again.";
        }
      } else {
        // Handle any other exceptions
        return "An unknown error occurred. Please try again.";
      }
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
