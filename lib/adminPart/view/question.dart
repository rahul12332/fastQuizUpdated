import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddQuestionScreen extends StatefulWidget {
  final String subjectName;
  final String mockName;

  AddQuestionScreen({required this.subjectName, required this.mockName});

  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = List.generate(
    4,
    (_) => TextEditingController(),
  ); // Only 4 options
  String? _correctAnswer;
  bool _isSaveEnabled = false;

  // Add question to Firestore
  Future<void> _addQuestion() async {
    final questionText = _questionController.text.trim();
    final options =
        _optionControllers
            .map((controller) => controller.text.trim())
            .where((option) => option.isNotEmpty)
            .toList();

    final correctAnswer = _correctAnswer?.trim();

    // Validation
    if (questionText.isNotEmpty &&
        options.length == _optionControllers.length &&
        correctAnswer != null &&
        options.contains(correctAnswer)) {
      try {
        final questionsCollection = FirebaseFirestore.instance
            .collection('series')
            .doc(widget.subjectName)
            .collection('mocks')
            .doc(widget.mockName)
            .collection('questions');

        await questionsCollection.add({
          'question': questionText,
          'options': options,
          'correctAnswer': correctAnswer,
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Question added successfully!')));

        // Clear fields after successful submission
        _questionController.clear();
        for (var controller in _optionControllers) {
          controller.clear();
        }

        setState(() {
          _correctAnswer = null;
          _isSaveEnabled = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add question. Please try again!')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly!')),
      );
    }
  }

  // Check form validity
  void _checkFormValidity() {
    setState(() {
      _isSaveEnabled =
          _questionController.text.trim().isNotEmpty &&
          _optionControllers.every(
            (controller) => controller.text.trim().isNotEmpty,
          ) &&
          _correctAnswer != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.subjectName} - ${widget.mockName} - Add Question',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(
                  labelText: 'Enter your question',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _checkFormValidity(),
              ),
              SizedBox(height: 16),
              for (int i = 0; i < 4; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    controller: _optionControllers[i],
                    decoration: InputDecoration(
                      labelText: 'Option ${i + 1}',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) {
                      _checkFormValidity();
                      setState(() {}); // Update dropdown options dynamically
                    },
                  ),
                ),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: _correctAnswer,
                hint: Text('Select correct answer'),
                isExpanded: true,
                onChanged: (String? newValue) {
                  setState(() {
                    _correctAnswer = newValue;
                    _checkFormValidity();
                  });
                },
                items:
                    _optionControllers
                        .map((controller) => controller.text.trim())
                        .where((option) => option.isNotEmpty)
                        .map(
                          (option) => DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          ),
                        )
                        .toList(),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: _isSaveEnabled ? _addQuestion : null,
                  child: Text('Save Question'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isSaveEnabled ? Colors.green : Colors.grey,
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
