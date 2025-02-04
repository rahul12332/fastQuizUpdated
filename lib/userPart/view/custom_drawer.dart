import 'package:fast_quiz_tayari/userPart/repostory/googleAuthRepo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/contant/appColor.dart';

class CustomDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? profilePicUrl;

  CustomDrawer({
    required this.userName,
    required this.userEmail,
    this.profilePicUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Custom Drawer Header
          Container(
            color: AppColor.theme.withOpacity(
              0.6,
            ), // Use AppColor.theme for background color
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      profilePicUrl != null
                          ? NetworkImage(profilePicUrl!)
                          : null,
                  child:
                      profilePicUrl == null
                          ? Icon(Icons.person, size: 40, color: Colors.white)
                          : null,
                ),
                SizedBox(height: 10),
                Text(
                  userName,
                  style: GoogleFonts.acme(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  userEmail,
                  style: GoogleFonts.acme(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),

          // Drawer Items
          /*  ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Navigate to Home Screen
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Navigate to Settings Screen
            },
          ),*/
          Spacer(),
          GestureDetector(
            onTap: () {
              AuthService.signOut(context);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                "Logout",
                style: GoogleFonts.abrilFatface(
                  letterSpacing: 2,
                  fontSize: 16,
                  color: Colors.deepOrangeAccent,
                ),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.orange, // Border color
                  width: 1.0, // Border width
                ),
                borderRadius: BorderRadius.circular(
                  8.0,
                ), // Optional: Rounded corners
              ),
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
