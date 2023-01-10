import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Blocs/Notes/notes_bloc.dart';
import 'package:notes/screens/notes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NotesBloc()
              ..add(
                LoadNotes(),
              ),
          )
        ],
        child: MaterialApp(
          title: 'Notes App',
          home: NotesList(),
          debugShowCheckedModeBanner: false,
        ));
  }
}
