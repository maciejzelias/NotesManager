import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:notes/databaseServices.dart';
import 'package:notes/helpers/dateHelpers.dart';
import 'package:notes/models/note.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc() : super(NotesLoading()) {
    final dbService = DatabaseServices();

    //initial loading notes
    on<LoadNotes>(((event, emit) async {
      emit(NotesLoading());
      final notesList = await dbService.getAllNotes();
      final filteredNotes = notesList.where((note) {
        return formatToShorterDate(note.data) ==
            getFormattedDateShorterSyntax();
      }).toList();
      emit(NotesLoaded(
        notes: filteredNotes,
        filteringDate: getFormattedDateShorterSyntax(),
      ));
    }));

    //adding note
    on<AddNote>(((event, emit) async {
      final state = this.state;
      await dbService.insertNote(event.note);

      if (state is NotesLoaded) {
        //check if added note should be automatically displayed in new state ( does it meet the filtering)
        String tresc = event.note.tresc ?? "";
        bool shouldBeAdded =
            (event.note.nazwa.contains(state.filteringText.trim()) ||
                    tresc.contains(state.filteringText.trim())) &&
                formatToShorterDate(event.note.data) == state.filteringDate &&
                (state.filteringState == 3 ||
                    state.filteringState == event.note.stan);
        List<Note> newNotes = List.from(state.notes);
        newNotes.add(event.note);
        emit(NotesLoaded(
            notes: shouldBeAdded ? newNotes : state.notes,
            filteringDate: state.filteringDate,
            filteringState: state.filteringState,
            filteringText: state.filteringText));
      }
    }));

    //updating note
    on<UpdateNote>(((event, emit) async {
      final state = this.state;
      await dbService.updateNote(event.note);
      if (state is NotesLoaded) {
        emit(NotesLoading());
        // if new properties of note dont meet the filtering requirments it should be removed
        String tresc = event.note.tresc ?? "";
        bool shouldBeAdded =
            (event.note.nazwa.contains(state.filteringText.trim()) ||
                    tresc.contains(state.filteringText.trim())) &&
                (state.filteringState == 3 ||
                    state.filteringState == event.note.stan);
        List<Note> newNotes = List.from(state.notes);
        if (shouldBeAdded) {
          // changing state in order to rebuild state with updated values
          emit(NotesLoading());
        } else {
          // when updated note dont meet filtering requirments
          newNotes.remove(event.note);
        }
        emit(NotesLoaded(
            notes: newNotes,
            filteringDate: state.filteringDate,
            filteringState: state.filteringState,
            filteringText: state.filteringText));
      }
    }));

    on<UpdateFiltering>(((event, emit) async {
      final state = this.state;
      final notesList = await dbService.getAllNotes();
      if (state is NotesLoaded) {
        String newDate = event.date != "" ? event.date : state.filteringDate;
        int newState = event.state != 5 ? event.state : state.filteringState;
        String newText = event.text != "" ? event.text : state.filteringText;

        final filteredNotes = notesList.where((note) {
          bool matchesTextFiltering = false;
          bool matchesDateFiltering = false;
          bool matchesStateFiltering = false;

          String tresc = note.tresc ?? "";
          //filtering by text
          matchesTextFiltering = (note.nazwa.contains(newText.trim()) ||
              tresc.contains(newText.trim()));

          matchesDateFiltering = formatToShorterDate(note.data) == newDate;

          matchesStateFiltering = newState == 3 || note.stan == newState;

          return matchesDateFiltering &&
              matchesStateFiltering &&
              matchesTextFiltering;
        }).toList();

        emit(NotesLoaded(
            notes: filteredNotes,
            filteringDate: newDate,
            filteringState: newState,
            filteringText: newText));
      }
    }));
  }
}
