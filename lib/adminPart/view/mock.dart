import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_quiz_tayari/adminPart/view/question.dart';
import 'package:flutter/material.dart';

class MockFolderScreen extends StatefulWidget {
  final String subjectName; // The selected subject name

  MockFolderScreen({required this.subjectName});

  @override
  _MockFolderScreenState createState() => _MockFolderScreenState();
}

class _MockFolderScreenState extends State<MockFolderScreen> {
  final TextEditingController _mockNameController = TextEditingController();

  // Method to add a new mock folder
  Future<void> _addMockFolder(String mockName) async {
    final mockCollection = FirebaseFirestore.instance
        .collection('series')
        .doc(widget.subjectName)
        .collection('mocks');

    final existingMock = await mockCollection.doc(mockName).get();

    if (existingMock.exists) {
      // Show error message if mock name already exists
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Folder "$mockName" already exists!')),
      );
    } else {
      // Add new mock folder
      await mockCollection.doc(mockName).set({'name': mockName});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Folder "$mockName" added successfully!')),
      );
      setState(() {}); // Refresh UI
    }
  }

  // Method to delete a mock folder
  Future<void> _deleteMockFolder(String mockName) async {
    final mockCollection = FirebaseFirestore.instance
        .collection('series')
        .doc(widget.subjectName)
        .collection('mocks');

    await mockCollection.doc(mockName).delete();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Folder "$mockName" deleted!')));
    setState(() {}); // Refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.subjectName} - Mocks')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('series')
            .doc(widget.subjectName)
            .collection('mocks')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Mocks Added'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddQuestionScreen(
                        subjectName: widget.subjectName,
                        mockName: doc['name'],
                      ),
                    ),
                  );
                },
                child: Card(
                  child: ListTile(
                    title: Text(doc['name']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteMockFolder(doc['name']);
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Mock Folder'),
                content: TextFormField(
                  controller: _mockNameController,
                  decoration: InputDecoration(
                    labelText: 'Mock Name (e.g., Mock 1)',
                    border: OutlineInputBorder(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final mockName = _mockNameController.text.trim();
                      if (mockName.isNotEmpty) {
                        _addMockFolder(mockName);
                        _mockNameController.clear();
                        Navigator.pop(context); // Close dialog
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
