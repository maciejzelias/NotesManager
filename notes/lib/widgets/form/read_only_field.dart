import 'package:flutter/material.dart';


class ReadOnlyField extends StatelessWidget {
  final String text;
  const ReadOnlyField({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(text),
        ));
  }
}
