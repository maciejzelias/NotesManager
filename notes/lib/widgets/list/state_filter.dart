import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_combo_box/components/combo_box.dart';

import '../../Blocs/Notes/notes_bloc.dart';

class StateFilter extends StatelessWidget {
  final List<String> _states = const ["draft", "accepted", "archived", "all"];
  final int filteringState;
  const StateFilter({required this.filteringState});

  @override
  Widget build(BuildContext context) {
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
              child: TileTitle(title: item, accent: Colors.red),
              value: item,
            );
          }).toList(),
          onChanged: (value) => context
              .read<NotesBloc>()
              .add(UpdateFiltering(state: _states.indexOf(value ?? "all"))),
          value: _states[filteringState],
        ),
      ),
    );
  }
}
