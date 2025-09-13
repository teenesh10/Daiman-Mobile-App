// ignore_for_file: library_private_types_in_public_api

import 'package:daiman_mobile/constants.dart';
import 'package:daiman_mobile/controllers/auth_controller.dart';
import 'package:daiman_mobile/custom_snackbar.dart';
import 'package:daiman_mobile/demo_mode.dart';
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

  _login() async {
    if (_passwordController.text.isEmpty || _emailController.text.isEmpty) {
      CustomSnackBar.showFailure(
          context, "Empty Fields", "Please fill in the fields.");
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

    setState(() {
      _isLoading = false;
    });

    if (error == "Login successful") {
      // Check if the email is verified
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && user.emailVerified) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        CustomSnackBar.showFailure(context, "Verification Required",
            "Please verify your email before logging in.");
      }
    } else {
      CustomSnackBar.showFailure(
          context, "Login Failed", "Invalid email or password!");
    }
  }

  _demoLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await DemoMode.enableDemoMode();
      CustomSnackBar.showSuccess(
          context, "Demo Mode", "Welcome to the demo!");
      Navigator.pushReplacementNamed(context, "/home");
    } catch (e) {
      CustomSnackBar.showFailure(
          context, "Demo Failed", "Could not start demo mode!");
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Theme.of(context).primaryColor),
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
                    backgroundColor: primaryColor,
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
              const SizedBox(height: 15),
              // Demo Mode Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _demoLogin,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: primaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Try Demo Mode",
                    style: TextStyle(fontSize: 16, color: primaryColor),
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
                      children: [
                        TextSpan(
                          text: "Register Now",
                          style: TextStyle(
                            // fontSize: 16,
                            color: Theme.of(context).primaryColor,
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
