import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddSubjectDialog extends StatelessWidget {
  final Function() onSubjectAdded;

  AddSubjectDialog({required this.onSubjectAdded});

  @override
  Widget build(BuildContext context) {
    final TextEditingController subjectController = TextEditingController();

    return AlertDialog(
      title: Text('Add Subject Folder'),
      content: TextFormField(
        controller: subjectController,
        decoration: InputDecoration(
          labelText: 'Folder Name (e.g., Maths, Reasoning)',
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
          onPressed: () async {
            String subjectName = subjectController.text.trim();

            if (subjectName.isNotEmpty) {
              // Add subject to Firestore
              await FirebaseFirestore.instance
                  .collection('series')
                  .doc(subjectName)
                  .set({'name': subjectName});

              onSubjectAdded(); // Notify parent to refresh UI
              Navigator.pop(context); // Close dialog
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
