import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Blocs/Notes/notes_bloc.dart';

class TextFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) {
        if (text.length > 2) {
          context.read<NotesBloc>().add(UpdateFiltering(text: text));
        } else if (text.length == 2) {
          context.read<NotesBloc>().add(UpdateFiltering(text: " "));
        }
      },
    );
  }
}
