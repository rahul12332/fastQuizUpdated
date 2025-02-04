import 'package:flutter/material.dart';

class SmokeyQuestionWidget extends StatelessWidget {
  final int serialNumber;
  final String question;

  SmokeyQuestionWidget({required this.serialNumber, required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0x66B1C29E)
            .withOpacity(0.2), // Smoky black color with opacity
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Aligns text properly if multiline
        children: [
          // Serial number (e.g., "1.")
          Text(
            '$serialNumber. ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          // The question text
          Expanded(
            child: Text(
              question,
              style: TextStyle(
                wordSpacing: 2,
                fontWeight: FontWeight.w100,
                fontSize: 15,
                color: Colors.black.withOpacity(0.6),
              ),
              maxLines: null, // Allows unlimited lines
              softWrap: true, // Enables text wrapping
            ),
          ),
        ],
      ),
    );
  }
}
