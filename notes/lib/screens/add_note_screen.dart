import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/models/note.dart';
import 'package:notes/widgets/form/confirm_button.dart';
import 'package:notes/widgets/form/field_title.dart';
import 'package:notes/widgets/form/input_field.dart';
import 'package:notes/widgets/form/read_only_field.dart';

import '../Blocs/Notes/notes_bloc.dart';
import '../helpers/dateHelpers.dart';

class AddingNoteScreen extends StatefulWidget {
  final bool _isNewNote;
  Note? _note;
  AddingNoteScreen(this._isNewNote);

  AddingNoteScreen.second(this._isNewNote, this._note);

  @override
  State<AddingNoteScreen> createState() => _AddingNoteScreenState();
}

class _AddingNoteScreenState extends State<AddingNoteScreen> {
  String _nazwa = '';
  String? _tresc = '';
  String _data = '';
  int _stan = 0;
  bool _isPreview = false;

  TextEditingController nazwaInputController = TextEditingController();
  TextEditingController trescInputController = TextEditingController();

  @override
  void initState() {
    if (!widget._isNewNote) {
      _nazwa = widget._note!.nazwa;
      _tresc = widget._note!.tresc;
      _data = widget._note!.data;
      _stan = widget._note!.stan;
      nazwaInputController.text = _nazwa;
      trescInputController.text = _tresc ?? "";
    }
    if (_stan == 2) {
      // preview mode (archived note)
      _isPreview = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    nazwaInputController.dispose();
    trescInputController.dispose();
    super.dispose();
  }

  void trySubmit(bool isLeft) {
    if (widget._isNewNote) {
      context.read<NotesBloc>().add(
            AddNote(
              note: Note(
                nazwa: nazwaInputController.text,
                tresc: trescInputController.text != ''
                    ? trescInputController.text
                    : null,
                data: getFormattedDate(),
                stan: isLeft ? 0 : 1,
              ),
            ),
          );
    } else {
      widget._note!.stan = isLeft ? 0 : 1;
      widget._note!.nazwa = nazwaInputController.text;
      widget._note!.tresc =
          trescInputController.text != '' ? trescInputController.text : null;
      context.read<NotesBloc>().add(UpdateNote(note: widget._note!));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => _isPreview
      ? SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: const Text('Preview of archived note'),
              elevation: 5,
            ),
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TitleOfField(title: "Nazwa"),
                    ReadOnlyField(text: _nazwa),
                    const SizedBox(
                      height: 10,
                    ),
                    TitleOfField(title: "Tresc"),
                    ReadOnlyField(text: _tresc ?? ""),
                    TitleOfField(title: "Data"),
                    ReadOnlyField(text: _data),
                    TitleOfField(title: "Stan"),
                    ReadOnlyField(text: _stan.toString()),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      : WillPopScope(
          child: SafeArea(
            child: Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  title: widget._isNewNote
                      ? const Text('Adding Note')
                      : const Text('Editing Note'),
                  elevation: 5,
                ),
                body: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TitleOfField(title: "Nazwa"),
                        InputField(
                            controller: nazwaInputController,
                            lines: 1,
                            input_key: 'note-name-field'),
                        const SizedBox(
                          height: 10,
                        ),
                        TitleOfField(title: "Tresc"),
                        InputField(
                            controller: trescInputController,
                            lines: 4,
                            input_key: 'note-description-field'),
                        if (!widget._isNewNote) ...[
                          TitleOfField(title: "Data"),
                          ReadOnlyField(text: _data),
                          TitleOfField(title: "Stan"),
                          ReadOnlyField(text: _stan.toString()),
                        ],
                        const SizedBox(
                          height: 10,
                        ),
                        ConfirmButton(
                          isNewNote: widget._isNewNote,
                          submit: trySubmit,
                        )
                      ],
                    ),
                  ),
                )),
          ),
          onWillPop: () async {
            trySubmit(true);
            return false;
          },
        );
}
