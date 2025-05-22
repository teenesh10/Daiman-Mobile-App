// ignore_for_file: library_private_types_in_public_api

import 'package:daiman_mobile/constants.dart';
import 'package:daiman_mobile/controllers/auth_controller.dart';
import 'package:daiman_mobile/custom_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  String? errorMessage;
  bool _isLoading = false;

  // Helper method to validate email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  // Login method with validation, loading, and custom snackbar
  _login() async {
    if (_passwordController.text.isEmpty) {
      CustomSnackBar.showFailure(
          context, "Password Error", "Password cannot be empty.");
      return;
    }
    if (_emailController.text.isEmpty) {
      CustomSnackBar.showFailure(
          context, "Email Error", "Email cannot be empty.");
      return;
    }
    if (!_isValidEmail(_emailController.text)) {
      CustomSnackBar.showFailure(
          context, "Invalid Email", "Please enter a valid email format.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Attempt login
    String? error = await _authController.login(
        _emailController.text, _passwordController.text);

    // Stop loading
    setState(() {
      _isLoading = false;
    });

    if (error == "Login successful") {
      // Check if the email is verified
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        // CustomSnackBar.showSuccess(context, "Login Success", "Welcome back!");
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        CustomSnackBar.showFailure(context, "Verification Required",
            "Please verify your email before logging in.");
      }
    } else {
      // Show error message if any
      CustomSnackBar.showFailure(
          context, "Login Failed", "User does not exist. Register now.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                "Welcome Back! It's nice to see you again.",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    fontSize: 28,
                    // fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.email),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.lock),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Loading spinner or error message
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/forgot_password");
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 250),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/register");
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          // fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      children: const [
                        TextSpan(
                          text: "Register Now",
                          style: TextStyle(
                            // fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
