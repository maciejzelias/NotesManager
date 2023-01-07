import 'package:flutter/material.dart';
import 'package:notes/screens/notes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Notes App',
      home: NotesList(),
      debugShowCheckedModeBanner: false,
    );
  }
}
