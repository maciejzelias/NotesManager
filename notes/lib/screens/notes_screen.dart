import 'package:flutter/material.dart';
import 'package:notes/widgets/note_card.dart';
import 'package:path/path.dart';

import '../databaseServices.dart';
import '../models/note.dart';
import 'add_note_screen.dart';

class NotesList extends StatefulWidget {
  const NotesList({Key? key}) : super(key: key);

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  List<Note> notesList = [];
  bool isLoading = false;
  DatabaseServices db = DatabaseServices();
  @override
  void initState() {
    fetchNotes();
    super.initState();
  }

  Future fetchNotes() async {
    setState(() {
      isLoading = true;
    });
    notesList = await db.getAllNotes();
    setState(() {
      isLoading = false;
    });
  }

  Widget archiveNoteButton(int index, BuildContext ctx) {
    return IconButton(
        onPressed: () async {
          final value = await showDialog<bool>(
              context: ctx,
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
            setState(() {
              Note note = notesList[index];
              note.stan = 2;
              db.updateNote(note);
            });
          }
        },
        icon: const Icon(
          Icons.delete,
          color: Colors.white,
        ));
  }

  Widget editNoteButton(int index, BuildContext ctx) {
    return IconButton(
        onPressed: () async {
          Note note = notesList[index];
          note.stan = 0;
          db.updateNote(note);
          await Navigator.push(
              ctx,
              MaterialPageRoute(
                builder: (context) => AddingNoteScreen.second(false, note),
              ));
          fetchNotes();
        },
        icon: const Icon(
          Icons.edit,
          color: Colors.white,
        ));
  }

  Color getColorOfNote(int stan) {
    switch (stan) {
      case 0:
        return const Color.fromARGB(255, 64, 148, 245);
      case 1:
        return const Color.fromARGB(255, 23, 129, 32);
      case 2:
        return const Color.fromARGB(166, 244, 6, 6);
      default:
        return const Color.fromARGB(255, 255, 255, 255);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes Manager"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: notesList.length,
          itemBuilder: ((context, index) {
            return Container(
              margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02,
                  horizontal: MediaQuery.of(context).size.width * 0.2),
              key: Key(notesList[index].id.toString()),
              color: getColorOfNote(notesList[index].stan),
              child: Column(
                children: [
                  NoteCard(note: notesList[index]),
                  Visibility(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        archiveNoteButton(index, context),
                        editNoteButton(index, context)
                      ],
                    ),
                    visible: notesList[index].stan != 2,
                  )
                ],
              ),
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddingNoteScreen(true),
              ));
          fetchNotes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
