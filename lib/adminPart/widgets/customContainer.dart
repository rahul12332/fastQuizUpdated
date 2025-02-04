import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final String text;

  const CustomContainer({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: const Color(0xFFD5E8D4), // Pastel green
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87, // Text color
          ),
        ),
      ),
    );
  }
}
