import 'package:equatable/equatable.dart';
import 'package:moneytracker/models/note_model.dart';


class NoteState extends Equatable {
  final bool loading;
  final List<NoteModel> notes;
  final String? error;

  const NoteState({
    required this.loading,
    required this.notes,
    this.error,
  });

  NoteState copyWith({
    bool? loading,
    List<NoteModel>? notes,
    String? error,
  }) {
    return NoteState(
      loading: loading ?? this.loading,
      notes: notes ?? this.notes,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, notes, error];

  static NoteState initial() => const NoteState(loading: true, notes: []);
}
