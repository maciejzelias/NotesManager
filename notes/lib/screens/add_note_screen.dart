import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';

class AddingNoteScreen extends StatefulWidget {
  final bool isNewNote;
  Note? note;
  AddingNoteScreen(this.isNewNote);

  AddingNoteScreen.second(this.isNewNote, this.note);

  @override
  State<AddingNoteScreen> createState() => _AddingNoteScreenState();
}

class _AddingNoteScreenState extends State<AddingNoteScreen> {
  String nazwa = '';
  String tresc = '';
  String data = '';
  int? stan;

  TextEditingController nazwaInputController = TextEditingController();
  TextEditingController trescInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isNewNote == false) {
      nazwa = widget.note!.nazwa;
      tresc = widget.note!.tresc!;
      data = widget.note!.data;
      stan = widget.note!.stan;
      nazwaInputController.text = nazwa;
      trescInputController.text = tresc;
    }
  }

  void trySubmit() {}

  Widget inputField(TextEditingController controller, int lines,) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        maxLines: lines,
        controller: controller,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            fillColor: Colors.grey[200],
            filled: true),
      ),
    );
  }

  Widget readOnlyField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            fillColor: Colors.grey[200],
            filled: true),
      ),
    );
  }

  Widget titleOfField(String title) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isNewNote
            ? const Text('Adding Note')
            : const Text('Editing Note'),
        elevation: 5,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          titleOfField("Nazwa"),
          inputField(nazwaInputController, 1),
          const SizedBox(
            height: 10,
          ),
          titleOfField("Tresc"),
          inputField(trescInputController, 4),
          if (widget.isNewNote) ...[
            titleOfField("Data"),
            titleOfField("Stan"),
            ]
        ],
      ),
    );
  }
}
