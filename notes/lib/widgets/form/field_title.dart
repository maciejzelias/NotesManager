import 'package:flutter/material.dart';

class TitleOfField extends StatelessWidget {
  final String title;
  const TitleOfField({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
