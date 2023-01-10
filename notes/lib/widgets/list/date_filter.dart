import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Blocs/Notes/notes_bloc.dart';
import '../../helpers/dateHelpers.dart';

class DateFilter extends StatelessWidget {
  final String filteringDate;
  const DateFilter({required this.filteringDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          filteringDate,
          textAlign: TextAlign.center,
        ),
        IconButton(
          icon: Icon(Icons.date_range),
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.parse(filteringDate),
                firstDate: DateTime(1950),
                lastDate: DateTime(2100));
            if (pickedDate != null) {
              context
                  .read<NotesBloc>()
                  .add(UpdateFiltering(date: formatDate(pickedDate)));
            }
          },
        ),
      ],
    );
  }
}
