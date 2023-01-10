import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Blocs/Notes/notes_bloc.dart';
import 'package:notes/widgets/list/date_filter.dart';
import 'package:notes/widgets/list/note_card.dart';
import 'package:notes/widgets/list/text_filter.dart';

import '../widgets/list/note_buttons.dart';
import '../widgets/list/state_filter.dart';
import 'add_note_screen.dart';

class NotesList extends StatelessWidget {
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          primary: true,
          child: BlocBuilder<NotesBloc, NotesState>(builder: (context, state) {
            if (state is NotesLoading) {
              return CircularProgressIndicator();
            } else if (state is NotesLoaded) {
              return Column(
                children: [
                  TextFilter(),
                  DateFilter(filteringDate: state.filteringDate),
                  StateFilter(filteringState: state.filteringState),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.notes.length,
                    itemBuilder: ((context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.02,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.2),
                        key: Key(state.notes[index].id.toString()),
                        color: getColorOfNote(state.notes[index].stan),
                        child: GestureDetector(
                          onDoubleTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddingNoteScreen.second(
                                      false, state.notes[index]),
                                ));
                          },
                          child: Column(
                            children: [
                              NoteCard(note: state.notes[index]),
                              Visibility(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ArchiveNoteButton(note: state.notes[index]),
                                    EditNoteButton(note: state.notes[index]),
                                  ],
                                ),
                                visible: state.notes[index].stan != 2,
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              );
            } else {
              return Text("Something went wrong");
            }
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
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
