part of 'notes_bloc.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<Note> notes;
  final String filteringText;
  final String filteringDate;
  final int filteringState;

  const NotesLoaded(
      {this.notes = const <Note>[],
      this.filteringText = "",
      this.filteringDate = "",
      this.filteringState = 3});

  @override
  List<Object> get props =>
      [notes, filteringDate, filteringState, filteringText];
}
