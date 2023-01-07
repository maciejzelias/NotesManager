import 'package:flutter/material.dart';
import 'package:notes/databaseServices.dart';
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

  void trySubmit() async {
    DatabaseServices db = DatabaseServices();
    if (widget.isNewNote) {
      await db.insertNote(Note(
          nazwa: nazwaInputController.text,
          data: DateTime.now().toString(),
          stan: 1));
    } else {}
    Navigator.of(context).pop();
  }

  Widget inputField(
    TextEditingController controller,
    int lines,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        maxLines: lines,
        controller: controller,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.blue,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            fillColor: Colors.grey[200],
            filled: true),
      ),
    );
  }

  Widget readOnlyField(String text) {
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

  Widget confirmButton() {
    return Container(
      alignment: Alignment.center,
      child: ElevatedButton.icon(
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
        onPressed: () => trySubmit(),
        label: widget.isNewNote
            ? const Text('Dodaj notatke !')
            : const Text('Zaktualizuj notatkę !'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: widget.isNewNote
              ? const Text('Adding Note')
              : const Text('Editing Note'),
          elevation: 5,
        ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    titleOfField("Nazwa"),
                    inputField(nazwaInputController, 1),
                    const SizedBox(
                      height: 10,
                    ),
                    titleOfField("Tresc"),
                    inputField(trescInputController, 4),
                    if (!widget.isNewNote) ...[
                      titleOfField("Data"),
                      readOnlyField(data),
                      titleOfField("Stan"),
                      readOnlyField(stan.toString()),
                    ],
                    const SizedBox(
                      height: 10,
                    ),
                    confirmButton()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
