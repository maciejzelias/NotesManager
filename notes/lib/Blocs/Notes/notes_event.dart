part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class LoadNotes extends NotesEvent {}

class AddNote extends NotesEvent {
  final Note note;

  const AddNote({required this.note});

  @override
  List<Object> get props => [note];
}

class UpdateNote extends NotesEvent {
  final Note note;

  const UpdateNote({required this.note});

  @override
  List<Object> get props => [note];
}

class UpdateFiltering extends NotesEvent {
  final String text;
  final String date;
  final int state;

  const UpdateFiltering({this.text: "", this.date: "", this.state: 5});

  @override
  List<Object> get props => [text, date, state];
}
