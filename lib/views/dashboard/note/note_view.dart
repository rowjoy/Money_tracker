import 'package:flutter/material.dart';
import 'package:moneytracker/utilis/colors.dart';
import 'package:moneytracker/views/dashboard/note/add_note_view.dart';

/// ------------------------------
/// SAMPLE MODEL + DATA
/// ------------------------------
class DailyNote {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final bool pinned;

  const DailyNote({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.pinned = false,
  });

  DailyNote copyWith({bool? pinned}) => DailyNote(
        id: id,
        title: title,
        content: content,
        createdAt: createdAt,
        pinned: pinned ?? this.pinned,
      );
}

final sampleNotes = <DailyNote>[
  DailyNote(
    id: 1,
    title: "Plan for today",
    content: "• Study 1 hour\n• Walk 20 min\n• Finish UI for wallet",
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    pinned: true,
  ),
  DailyNote(
    id: 2,
    title: "Shopping list",
    content: "Rice, Eggs, Milk, Soap",
    createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
  ),
  DailyNote(
    id: 3,
    title: "Idea",
    content: "Add note suggestions + export DB in settings.",
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
];

/// ------------------------------
/// PREMIUM NOTE VIEW
/// - Search + clear
/// - Filter chips (All / Pinned / Today)
/// - Swipe actions (Pin / Delete)
/// - Undo snackbar
/// - Premium card UI (matches your style)
/// ------------------------------
class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

enum NoteFilter { all, pinned, today }

class _NoteViewState extends State<NoteView> {
  final _searchCtrl = TextEditingController();
  late List<DailyNote> _notes;
  NoteFilter _filter = NoteFilter.all;

  @override
  void initState() {
    super.initState();
    _notes = List.of(sampleNotes);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchCtrl.text.trim().toLowerCase();

    List<DailyNote> filtered = _notes.where((n) {
      if (query.isEmpty) return true;
      return n.title.toLowerCase().contains(query) ||
          n.content.toLowerCase().contains(query);
    }).toList();

    // Apply filter
    filtered = filtered.where((n) {
      switch (_filter) {
        case NoteFilter.all:
          return true;
        case NoteFilter.pinned:
          return n.pinned;
        case NoteFilter.today:
          final now = DateTime.now();
          return n.createdAt.year == now.year &&
              n.createdAt.month == now.month &&
              n.createdAt.day == now.day;
      }
    }).toList();

    // Sort: pinned first, then newest
    filtered.sort((a, b) {
      if (a.pinned != b.pinned) return b.pinned ? 1 : -1;
      return b.createdAt.compareTo(a.createdAt);
    });

    return Scaffold(
      backgroundColor: ProjectColor.whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ProjectColor.whiteColor,
        elevation: 0,
        title: const Text(
          "Daily Notes",
          style: TextStyle(
            color: ProjectColor.blackColor,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            tooltip: "Add note",
            onPressed: () async {
              final created = await Navigator.push<DailyNote?>(
                context,
                MaterialPageRoute(builder: (_) => const AddNotePage()),
              );
              if (created != null && mounted) {
                setState(() => _notes.insert(0, created));
              }
            },
            icon: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: ProjectColor.lavenderPurple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: ProjectColor.lavenderPurple.withOpacity(0.25),
                ),
              ),
              child: const Icon(
                Icons.add,
                color: ProjectColor.electricPurple,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _premiumHeaderCard(),
            const SizedBox(height: 12),

            _premiumSearch(
              onChanged: (_) => setState(() {}),
              onClear: () {
                _searchCtrl.clear();
                setState(() {});
              },
            ),
            const SizedBox(height: 12),

            _filterChips(),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Notes (${filtered.length})",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: ProjectColor.blackColor,
                  ),
                ),
                Text(
                  _filterLabel(),
                  style: TextStyle(
                    fontSize: 12,
                    color: ProjectColor.grey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (filtered.isEmpty)
              _emptyStatePremium()
            else
              ...filtered.map((n) => _dismissibleNoteCard(n)),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  /// ------------------------------
  /// UI PARTS
  /// ------------------------------
  Widget _premiumHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProjectColor.lavenderPurple.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ProjectColor.lavenderPurple.withOpacity(0.25)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 12,
            offset: Offset(0, 10),
            color: Color(0x10000000),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12),
            ),
            child: const Icon(
              Icons.auto_awesome_outlined,
              color: ProjectColor.electricPurple,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Smart Daily Notes",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 4),
                Text(
                  "Swipe to pin or delete • Use filters • Search quickly",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _premiumSearch({
    required ValueChanged<String> onChanged,
    required VoidCallback onClear,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: TextField(
        controller: _searchCtrl,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: "Search notes…",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchCtrl.text.trim().isEmpty
              ? null
              : IconButton(
                  tooltip: "Clear",
                  onPressed: onClear,
                  icon: const Icon(Icons.close),
                ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }

  Widget _filterChips() {
    return Row(
      children: [
        Expanded(
          child: _chip(
            label: "All",
            active: _filter == NoteFilter.all,
            onTap: () => setState(() => _filter = NoteFilter.all),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _chip(
            label: "Pinned",
            active: _filter == NoteFilter.pinned,
            onTap: () => setState(() => _filter = NoteFilter.pinned),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _chip(
            label: "Today",
            active: _filter == NoteFilter.today,
            onTap: () => setState(() => _filter = NoteFilter.today),
          ),
        ),
      ],
    );
  }

  Widget _chip({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    final bg = active
        ? ProjectColor.lavenderPurple.withOpacity(0.12)
        : Colors.white;
    final border = active
        ? ProjectColor.lavenderPurple.withOpacity(0.35)
        : Colors.black12;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: border),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: active ? ProjectColor.electricPurple : ProjectColor.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _dismissibleNoteCard(DailyNote note) {
    return Dismissible(
      key: ValueKey(note.id),
      direction: DismissDirection.horizontal,
      background: _swipeBg(
        icon: Icons.push_pin,
        text: note.pinned ? "Unpin" : "Pin",
        color: ProjectColor.electricPurple,
        alignLeft: true,
      ),
      secondaryBackground: _swipeBg(
        icon: Icons.delete,
        text: "Delete",
        color: Colors.red,
        alignLeft: false,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _confirmDelete(context);
        }
        return true;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          _deleteWithUndo(note);
        } else {
          _togglePin(note);
        }
      },
      child: _premiumNoteCard(
        note: note,
        onTap: () => _openDetail(note),
        onPinToggle: () => _togglePin(note),
        onDelete: () => _deleteWithUndo(note),
      ),
    );
  }

  Widget _premiumNoteCard({
    required DailyNote note,
    required VoidCallback onTap,
    required VoidCallback onPinToggle,
    required VoidCallback onDelete,
  }) {
    final chipBg = ProjectColor.lavenderPurple.withOpacity(0.08);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 8),
            color: Color(0x0F000000),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: note.pinned ? const Color(0xFFFFF3C8) : chipBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12),
                ),
                child: Icon(
                  note.pinned ? Icons.push_pin : Icons.sticky_note_2_outlined,
                  color: ProjectColor.electricPurple,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            note.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Text(
                          _formatShort(note.createdAt),
                          style: const TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        _actionChip(
                          label: note.pinned ? "Unpin" : "Pin",
                          icon: note.pinned ? Icons.push_pin : Icons.push_pin_outlined,
                          onTap: onPinToggle,
                        ),
                        const SizedBox(width: 8),
                        _actionChip(
                          label: "Delete",
                          icon: Icons.delete_outline,
                          onTap: onDelete,
                          danger: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool danger = false,
  }) {
    final color = danger ? Colors.red : ProjectColor.electricPurple;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyStatePremium() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProjectColor.lavenderPurple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ProjectColor.lavenderPurple.withOpacity(0.20)),
      ),
      child: const Row(
        children: [
          Icon(Icons.inbox_outlined, color: ProjectColor.grey),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "No notes found. Tap + to create your first note.",
              style: TextStyle(color: ProjectColor.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _swipeBg({
    required IconData icon,
    required String text,
    required Color color,
    required bool alignLeft,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Align(
        alignment: alignLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ------------------------------
  /// ACTIONS
  /// ------------------------------
  void _togglePin(DailyNote note) {
    setState(() {
      final idx = _notes.indexWhere((x) => x.id == note.id);
      if (idx != -1) {
        _notes[idx] = _notes[idx].copyWith(pinned: !_notes[idx].pinned);
      }
    });
  }

  void _deleteWithUndo(DailyNote note) {
    final removedIndex = _notes.indexWhere((x) => x.id == note.id);
    if (removedIndex == -1) return;

    setState(() => _notes.removeAt(removedIndex));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Note deleted"),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            setState(() => _notes.insert(removedIndex, note));
          },
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete note?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          )
        ],
      ),
    );
    return ok ?? false;
  }

  String _filterLabel() {
    switch (_filter) {
      case NoteFilter.all:
        return "All notes";
      case NoteFilter.pinned:
        return "Pinned only";
      case NoteFilter.today:
        return "Today only";
    }
  }

  void _openDetail(DailyNote note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Material(
            borderRadius: BorderRadius.circular(18),
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          note.title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                        ),
                      ),
                      if (note.pinned)
                        const Icon(Icons.push_pin, size: 18, color: ProjectColor.electricPurple),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatLong(note.createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 12),
                  Text(note.content),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// ------------------------------
/// DATE HELPERS
/// ------------------------------
String _formatShort(DateTime dt) {
  final d = dt.day.toString().padLeft(2, '0');
  final m = dt.month.toString().padLeft(2, '0');
  return "$d/$m";
}

String _formatLong(DateTime dt) {
  final d = dt.day.toString().padLeft(2, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final y = dt.year.toString();
  final hh = dt.hour.toString().padLeft(2, '0');
  final mm = dt.minute.toString().padLeft(2, '0');
  return "$d/$m/$y  $hh:$mm";
}
