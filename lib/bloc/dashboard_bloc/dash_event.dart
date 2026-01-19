abstract class IndexEvent{}


class DeshBoardChanged extends IndexEvent {
    final int index;
    DeshBoardChanged(this.index);
}