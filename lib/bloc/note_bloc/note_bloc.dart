import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneytracker/repo/note_repo.dart';
import 'note_event.dart';
import 'note_state.dart';


class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository repo;

  NoteBloc(this.repo) : super(NoteState.initial()) {
    on<NoteLoadRequested>((event, emit) async {
      emit(state.copyWith(loading: true));
      try {
        final notes = await repo.getAllNotes();
        emit(state.copyWith(loading: false, notes: notes));
      } catch (e) {
        emit(state.copyWith(loading: false, error: e.toString()));
      }
    });

    on<NoteAddRequested>((event, emit) async {
      await repo.addNote(event.note);
      add(NoteLoadRequested()); // ✅ reload list (realtime)
    });

    on<NoteDeleteRequested>((event, emit) async {
      await repo.deleteNote(event.id);
      add(NoteLoadRequested());
    });

    on<NoteTogglePinRequested>((event, emit) async {
      await repo.togglePin(event.id, event.pinned);
      add(NoteLoadRequested());
    });
  }
}
