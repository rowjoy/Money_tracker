import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneytracker/utilis/colors.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _titleCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _focus = FocusNode();

  bool _pinned = false;
  bool _checklistMode = false;

  // For checklist mode
  final List<_CheckItem> _items = [];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _toggleChecklist() {
    setState(() {
      _checklistMode = !_checklistMode;

      if (_checklistMode) {
        // Convert current note text to checklist items
        _items
          ..clear()
          ..addAll(_noteCtrl.text
              .split('\n')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .map((e) => _CheckItem(text: e)));
        _noteCtrl.clear();
      } else {
        // Convert checklist items back to text
        _noteCtrl.text = _items.map((e) => e.text).join('\n');
        _items.clear();
      }
    });
  }

  void _save() {
    FocusManager.instance.primaryFocus?.unfocus();

    final title = _titleCtrl.text.trim();
    final content = _checklistMode
        ? _items.map((e) => "${e.done ? "[x]" : "[ ]"} ${e.text}").join('\n')
        : _noteCtrl.text.trim();

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Write something first 🙂")),
      );
      return;
    }

    // ✅ Return data to NoteView (you can replace with your model)
    Navigator.pop(context, {
      "title": title.isEmpty ? "Untitled" : title,
      "content": content,
      "pinned": _pinned,
      "createdAt": DateTime.now().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = const Color(0xFFF3F1FF); // same feel like note header card

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "New Note",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
        ),
        actions: [
          IconButton(
            tooltip: _pinned ? "Unpin" : "Pin",
            onPressed: () => setState(() => _pinned = !_pinned),
            icon: Icon(
              _pinned ? Icons.push_pin : Icons.push_pin_outlined,
              color: _pinned ? Colors.black : Colors.black54,
            ),
          ),
          IconButton(
            tooltip: "Checklist",
            onPressed: _toggleChecklist,
            icon: Icon(
              _checklistMode ? Icons.checklist : Icons.checklist_outlined,
              color: _checklistMode ? Colors.black : Colors.black54,
            ),
          ),
          const SizedBox(width: 6),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: _save,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: ProjectColor.lavenderPurple.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ProjectColor.lavenderPurple.withOpacity(0.25),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: ProjectColor.blackColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title (optional)
                TextField(
                  controller: _titleCtrl,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Title",
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _focus.requestFocus(),
                ),
                const Divider(height: 14),

                // Editor area
                if (!_checklistMode)
                  TextField(
                    controller: _noteCtrl,
                    focusNode: _focus,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 10,
                    style: const TextStyle(fontSize: 14, height: 1.35),
                    decoration: const InputDecoration(
                      hintText: "Note",
                      border: InputBorder.none,
                    ),
                  )
                else
                  _ChecklistEditor(
                    items: _items,
                    onAddNewLine: (text) {
                      if (text.trim().isEmpty) return;
                      setState(() => _items.add(_CheckItem(text: text.trim())));
                    },
                    onToggle: (i) => setState(() => _items[i].done = !_items[i].done),
                    onDelete: (i) => setState(() => _items.removeAt(i)),
                    onEdit: (i, v) => setState(() => _items[i].text = v),
                  ),

                const SizedBox(height: 10),

                // Small bottom actions like keep
                Row(
                  children: [
                    _miniAction(
                      icon: Icons.content_copy_outlined,
                      text: "Copy",
                      onTap: () async {
                        final txt = _checklistMode
                            ? _items.map((e) => e.text).join('\n')
                            : _noteCtrl.text;
                        if (txt.trim().isEmpty) return;
                        await Clipboard.setData(ClipboardData(text: txt));
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Copied")),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    _miniAction(
                      icon: Icons.clear_all,
                      text: "Clear",
                      onTap: () {
                        setState(() {
                          _titleCtrl.clear();
                          _noteCtrl.clear();
                          _items.clear();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _miniAction({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: ProjectColor.grey),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                color: ProjectColor.grey,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckItem {
  String text;
  bool done;
  _CheckItem({required this.text, this.done = false});
}

class _ChecklistEditor extends StatefulWidget {
  final List<_CheckItem> items;
  final void Function(String text) onAddNewLine;
  final void Function(int index) onToggle;
  final void Function(int index) onDelete;
  final void Function(int index, String value) onEdit;

  const _ChecklistEditor({
    required this.items,
    required this.onAddNewLine,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<_ChecklistEditor> createState() => _ChecklistEditorState();
}

class _ChecklistEditorState extends State<_ChecklistEditor> {
  final _newCtrl = TextEditingController();

  @override
  void dispose() {
    _newCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(widget.items.length, (i) {
          final item = widget.items[i];
          return Row(
            children: [
              Checkbox(
                value: item.done,
                onChanged: (_) => widget.onToggle(i),
                activeColor: ProjectColor.electricPurple,
              ),
              Expanded(
                child: TextFormField(
                  initialValue: item.text,
                  onChanged: (v) => widget.onEdit(i, v),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "List item",
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    decoration: item.done ? TextDecoration.lineThrough : null,
                    color: item.done ? Colors.black54 : Colors.black,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => widget.onDelete(i),
                icon: const Icon(Icons.close, size: 18),
              )
            ],
          );
        }),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.add, color: Colors.black54),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _newCtrl,
                decoration: const InputDecoration(
                  hintText: "Add item…",
                  border: InputBorder.none,
                ),
                onSubmitted: (v) {
                  widget.onAddNewLine(v);
                  _newCtrl.clear();
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
