import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/widgets/note_card.dart';

import 'package:flutter_combo_box/components/combo_box.dart';

import '../databaseServices.dart';
import '../models/note.dart';
import 'add_note_screen.dart';

class NotesList extends StatefulWidget {
  const NotesList({Key? key}) : super(key: key);

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  List<Note> _notesList = [];
  List<Note> _filteredNotesList = [];
  String _filteringText = '';
  String _prevDate = "";
  stateOfNote _noteFilterinState = stateOfNote.all;
  List<stateOfNote> _states = [
    stateOfNote.all,
    stateOfNote.accepted,
    stateOfNote.archived,
    stateOfNote.draft
  ];
  TextEditingController _dateInputController = TextEditingController();
  DatabaseServices _db = DatabaseServices();
  @override
  void initState() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    _dateInputController.text = formattedDate;
    fetchNotes();
    super.initState();
  }

  Future fetchNotes() async {
    _notesList = await _db.getAllNotes();
    filterList();
    setState(() {});
  }

  void filterList() {
    _filteredNotesList = _notesList;
    if (_filteringText.length > 2)
      //filtering with name / description
      _filteredNotesList = _filteredNotesList.where((note) {
        bool isMatched = false;
        String nazwa = note.nazwa;
        String tresc = note.tresc ?? "";
        String trimmedText = _filteringText.trim();
        if (nazwa.length >= trimmedText.length) {
          String str = nazwa.substring(0, trimmedText.length);
          isMatched = str == trimmedText;
        }
        if (!isMatched && tresc.length >= trimmedText.length) {
          String str = tresc.substring(0, trimmedText.length);
          isMatched = str == trimmedText;
        }
        return isMatched;
      }).toList();

    //filtering with date
    if (_prevDate != _dateInputController.text) {
      //preventing sorting by date on every keystroke
      _filteredNotesList = _filteredNotesList.where((note) {
        String dateWithoutHour = note.data.substring(0, 10);
        return dateWithoutHour == _dateInputController.text;
      }).toList();
      _prevDate = _dateInputController.text;
    }

    //filtering by state
    switch (_noteFilterinState) {
      case stateOfNote.all:
        break;
      case stateOfNote.accepted:
        _filteredNotesList =
            _filteredNotesList.where((note) => note.stan == 1).toList();
        break;
      case stateOfNote.draft:
        _filteredNotesList =
            _filteredNotesList.where((note) => note.stan == 0).toList();
        break;
      case stateOfNote.archived:
        _filteredNotesList =
            _filteredNotesList.where((note) => note.stan == 2).toList();
        break;
    }
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
              Note note = _filteredNotesList[index];
              note.stan = 2;
              _db.updateNote(note);
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
          Note note = _filteredNotesList[index];
          note.stan = 0;
          _db.updateNote(note);
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

  Widget textFilter() {
    return TextField(
      onChanged: (text) {
        if (text.length > 2) {
          _filteringText = text;
          setState(() {
            filterList();
          });
        } else if (text.length == 2) {
          _filteringText = "";
          // _filteredNotesList = notesList;
          setState(() {
            filterList();
          });
        }
      },
    );
  }

  Widget dateFilter(BuildContext ctx) {
    return Column(
      children: [
        TextField(
          enabled: false,
          controller: _dateInputController,
          textAlign: TextAlign.center,
        ),
        IconButton(
          icon: Icon(Icons.date_range),
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
                context: ctx,
                initialDate: DateTime.parse(_dateInputController.text),
                firstDate: DateTime(1950),
                lastDate: DateTime(2100));
            if (pickedDate != null) {
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
              setState(() {
                _dateInputController.text = formattedDate;
                filterList();
              });
            }
          },
        ),
      ],
    );
  }

  Widget comboBoxFilter() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            labelText: 'State',
          ),
          items: _states.map((item) {
            return DropdownMenuItem(
              child: TileTitle(title: item.toString(), accent: Colors.red),
              value: item.toString(),
            );
          }).toList(),
          onChanged: (value) => setState(() {
            _noteFilterinState = stateOfNote.values.byName(value!);
            filterList();
          }),
          value: _noteFilterinState.toString(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes Manager"),
      ),
      body: Container(
        child: SingleChildScrollView(
          primary: true,
          child: Column(
            children: [
              textFilter(),
              dateFilter(context),
              comboBoxFilter(),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _filteredNotesList.length,
                itemBuilder: ((context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02,
                        horizontal: MediaQuery.of(context).size.width * 0.2),
                    key: Key(_filteredNotesList[index].id.toString()),
                    color: getColorOfNote(_filteredNotesList[index].stan),
                    child: GestureDetector(
                      onDoubleTap: () async {
                        Note note = _filteredNotesList[index];
                        if (_filteredNotesList[index].stan != 2) {
                          //normal note - in stan 0 or 1, normal edit performance
                          note.stan = 0;
                          _db.updateNote(note);
                          fetchNotes();
                        }
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddingNoteScreen.second(false, note),
                            ));
                      },
                      child: Column(
                        children: [
                          NoteCard(note: _filteredNotesList[index]),
                          Visibility(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                archiveNoteButton(index, context),
                                editNoteButton(index, context)
                              ],
                            ),
                            visible: _filteredNotesList[index].stan != 2,
                          )
                        ],
                      ),
                    ),
                  );
                }),
              )
            ],
          ),
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

enum stateOfNote {
  all,
  accepted,
  draft,
  archived;

  @override
  String toString() => this.name;
}
