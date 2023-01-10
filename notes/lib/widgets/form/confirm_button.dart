import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final Function submit;
  final bool isNewNote;
  const ConfirmButton({required this.submit, required this.isNewNote});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: ElevatedButton.icon(
        key: const Key('add-note-button'),
        icon: const Icon(
          Icons.send,
          color: Colors.white,
          size: 20,
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.blue,
          onPrimary: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
        onPressed: () => submit(false),
        label: isNewNote
            ? const Text('Dodaj notatke !')
            : const Text('Zaktualizuj notatkę !'),
      ),
    );
  }
}
