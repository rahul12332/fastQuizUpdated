import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../core/routes.dart';
import '../domain/sharedPre.dart';
import '../widgets/seriesWideget.dart';
import 'custom_drawer.dart';

class UserDasboard extends StatefulWidget {
  const UserDasboard({super.key});

  @override
  State<UserDasboard> createState() => _UserDasboardState();
}

class _UserDasboardState extends State<UserDasboard> {
  @override
  String? userName;
  String? userEmail;
  String? profilePicUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    userName = await SharedPrefs().getName();
    userEmail = await SharedPrefs().getEmail();
    profilePicUrl = await SharedPrefs().getImage();
    setState(() {});
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        userName: userName.toString(),
        userEmail: userEmail.toString(),
        profilePicUrl: profilePicUrl.toString(), // Pass a URL if available
      ),
      appBar: AppBar(
        title: Text('Mock Series '),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('series').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Folders Added'));
          }
          for (var doc in snapshot.data!.docs) {
            print("🔥 Series Data: ${doc.data()}");
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ), // Add padding around the grid
            child: Wrap(
              spacing: 20.0, // Horizontal spacing between items
              runSpacing: 20.0, // Vertical spacing between rows
              children: snapshot.data!.docs.map((doc) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.subjectMockList,
                      arguments:
                          doc['name'], // Passing subjectName as an argument
                    );
                  },
                  child: CustomSeriesWidget(subject: doc['name']),
                );
              }).toList(), // Convert the mapped widgets to a list
            ),
          );
        },
      ),
    );
  }
}
