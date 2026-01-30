import 'package:equatable/equatable.dart';
import 'package:moneytracker/models/note_model.dart';


abstract class NoteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class NoteLoadRequested extends NoteEvent {}

class NoteAddRequested extends NoteEvent {
  final NoteModel note;
  NoteAddRequested(this.note);

  @override
  List<Object?> get props => [note];
}


class NoteDeleteRequested extends NoteEvent {
  final int id;
  NoteDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}


class NoteTogglePinRequested extends NoteEvent {
  final int id;
  final bool pinned;
  NoteTogglePinRequested(this.id, this.pinned);

  @override
  List<Object?> get props => [id, pinned];
}

