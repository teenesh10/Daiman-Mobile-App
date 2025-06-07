import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> login(String email, String password) async {
    try {
      // Attempt to sign in the user
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.reload();
      User? user = _auth.currentUser;

      if (!user!.emailVerified) {
        await _auth.signOut();
        return "Please verify your email.";
      }

      // Save login status to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', email);
      await prefs.setString('userPassword', password);

      return "Login successful";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unexpected error occurred.";
    }
  }

  Future<String?> register(
      String username, String email, String password) async {
    try {
      // Attempt to create a new user
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.sendEmailVerification();

      // Save user data to Firestore with verification flag set to false
      await _firestore.collection('user').doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
      });

      return "Verification link sent to your email.";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "This email already exists.";
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> updateEmailVerificationStatus(String uid) async {
    await _firestore.collection('user').doc(uid).update({'isVerified': true});
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "success";
    } catch (e) {
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
        return "An unknown error occurred. Please try again.";
      }
    }
  }

  Future<void> logout() async {
    await _auth.signOut();

    // Clear user data in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn');
    prefs.remove('userID');
    prefs.remove('userEmail');
    prefs.remove('userPassword');
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot snapshot =
            await _firestore.collection('user').doc(user.uid).get();
        return snapshot.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  Future<DateTime?> getUserJoinedDate() async {
    try {
      User? user = _auth.currentUser;
      return user?.metadata.creationTime;
    } catch (e) {
      print("Error fetching joined date: $e");
      return null;
    }
  }

  Future<void> deleteUserCompletely() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('user').doc(user.uid).delete();
      // Delete user Authentication account
      await user.delete();
    }
  }

  Future<void> checkUserStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.reload();
        user = FirebaseAuth.instance.currentUser;

        if (user == null) {
          await logout();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          await logout();
        }
      } catch (e) {
        print('Unexpected error during user reload: $e');
      }
    }
  }
}
