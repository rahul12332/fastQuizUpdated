import 'package:fast_quiz_tayari/userPart/view/dasboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../core/contant/appColor.dart';
import '../domain/sharedPre.dart';

class LoginScreen extends StatelessWidget {
  @override
  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // If the user cancels the sign-in process
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      // Return the signed-in user
      final User? user = userCredential.user;

      if (user != null) {
        // Save token and email in SharedPreferences
        final sharedPrefs = SharedPrefs();
        await sharedPrefs.saveToken(googleAuth.accessToken ?? "");
        await sharedPrefs.saveEmail(user.email ?? "");
        await sharedPrefs.saveName(user.displayName ?? "");
        await sharedPrefs.saveImage(user.photoURL ?? "");

        String? savedToken = await sharedPrefs.getToken();

        print("Token saved: ${savedToken}");
        print("Email saved: ${user.email}");

        // Navigate to UserDashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserDasboard()),
        );

        // Show success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Login successfully!",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Acme', // Google Font Acme
              ),
            ),
            backgroundColor: AppColor.theme,
            duration: Duration(seconds: 3),
          ),
        );
      }

      return user;
    } catch (e) {
      print("Error signing in with Google: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: Unable to sign in",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Acme', // Google Font Acme
            ),
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return null;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // Background image for the entire scaffold
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.22),
            Text(
              'Fast Quiz',
              style: GoogleFonts.acme(
                fontSize: 40,
                fontWeight: FontWeight.w600,
                color: AppColor.splash_theme,
                letterSpacing: 1,
              ),
            ),

            // "tayari" Text
            Text(
              'Tayari',
              style: GoogleFonts.abhayaLibre(
                fontSize: 22,
                letterSpacing: 1,
                fontWeight: FontWeight.w300,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                signInWithGoogle(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.theme, // Border color
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(5.0), // Rounded corners
                  color: Colors.white.withOpacity(
                    0.9,
                  ), // Semi-transparent background
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/google.png', // Replace with your Google icon path
                      height: 24,
                      width: 24,
                      color: Colors.orangeAccent,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Login with Google",
                      style: GoogleFonts.actor(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                        color: AppColor.theme,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Image.asset("assets/login.png"),
            ),
          ],
        ),
      ),
    );
  }
}
