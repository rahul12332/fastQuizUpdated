import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/customContainer.dart';
import '../widgets/dailog.dart';
import 'mock.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Series Folder')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('series').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Folders Added'));
          }

          return ListView(
            children:
                snapshot.data!.docs.map((doc) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  MockFolderScreen(subjectName: doc['name']),
                        ),
                      );
                    },
                    child: CustomContainer(text: doc['name']),
                  );
                }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (context) => AddSubjectDialog(
                  onSubjectAdded: () {
                    setState(() {}); // Refresh UI after adding subject
                  },
                ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
