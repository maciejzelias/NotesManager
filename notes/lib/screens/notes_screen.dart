import 'package:flutter/material.dart';

import '../databaseServices.dart';
import '../models/note.dart';
import 'add_note_screen.dart';

class NotesList extends StatefulWidget {
  const NotesList({Key? key}) : super(key: key);

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  DatabaseServices db = DatabaseServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes Manager"),
      ),
      body: Center(
        child: FutureBuilder<List<Note>>(
          future: db.getAllNotes(),
          builder: (BuildContext buildContext, AsyncSnapshot<List<Note>> snap) {
            if (!snap.hasData) {
              return const Center(
                child: Text('Loading'),
              );
            }
            return snap.data!.isEmpty
                ? const Center(
                    child: Text("There are no notes in database"),
                  )
                : ListView(
                    children: snap.data!.map((note) {
                      return Center(
                        child: ListTile(
                          title: Text(note.nazwa),
                        ),
                      );
                    }).toList(),
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddingNoteScreen(true),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
