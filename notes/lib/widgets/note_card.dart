import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  const NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
        // removes grayish color
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          children: [
            Text(
              note.nazwa,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
            const Divider(
              height: 15,
              thickness: 1,
              color: Colors.white,
            ),
            Text(
              note.data,
              style: const TextStyle(color: Colors.white),
            ),
            if (note.tresc != null) ...[
              const Divider(
                height: 15,
                thickness: 1,
                color: Colors.white,
              ),
              Text(
                note.tresc!,
                style: const TextStyle(color: Colors.white),
              ),
            ]
          ],
        ));
  }
}
