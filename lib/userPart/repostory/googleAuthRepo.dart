import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../domain/sharedPre.dart';
import '../view/login.dart';
import '../widgets/customCircularProgressIndicatior.dart'; // Replace with your login screen

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Method to sign out and clear preferences
  static Future<void> signOut(BuildContext context) async {
    try {
      // Show the progress dialog
      ProgressDialog.show(context, true);

      // Sign out from Google
      await _googleSignIn.signOut();

      // Clear SharedPreferences
      SharedPrefs prefs = SharedPrefs();
      await prefs.clearUserData();

      // Close the progress dialog
      ProgressDialog.show(context, false);

      // Navigate to Login Screen directly
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(), // Replace with your login screen
        ),
      );
    } catch (error) {
      // Close the progress dialog in case of error
      ProgressDialog.show(context, false);

      print("Error signing out: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out. Please try again.')),
      );
    }
  }
}
