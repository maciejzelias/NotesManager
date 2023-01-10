import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Blocs/Notes/notes_bloc.dart';
import '../../models/note.dart';
import '../../screens/add_note_screen.dart';

class ArchiveNoteButton extends StatelessWidget {
  final Note note;
  const ArchiveNoteButton({required this.note});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          final value = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('Are you sure you want to archieve that note?'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              });
          if (value == true) {
            //updating note to
            note.stan = 2;
            context.read<NotesBloc>().add(
                  UpdateNote(
                    note: note,
                  ),
                );
          }
        },
        icon: const Icon(
          Icons.delete,
          color: Colors.white,
        ));
  }
}

class EditNoteButton extends StatelessWidget {
  final Note note;
  const EditNoteButton({required this.note});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddingNoteScreen.second(false, note),
              ));
        },
        icon: const Icon(
          Icons.edit,
          color: Colors.white,
        ));
  }
}
