
// =====================================================
// 6) PAGE 2: ADD BAZAAR (BottomSheet) + Suggestions
// =====================================================
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:moneytracker/bloc/bazaar/bazaar_bloc.dart';
import 'package:moneytracker/bloc/bazaar/bazaar_event.dart';

import '../../../../bloc/bazaar/bazaar_states.dart';
import '../../../../utilis/colors.dart';

class AddBazaarSheet extends StatefulWidget {
  const AddBazaarSheet({super.key});

  @override
  State<AddBazaarSheet> createState() => _AddBazaarSheetState();
}

class _AddBazaarSheetState extends State<AddBazaarSheet> {
  final _nameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameCtrl.text.trim();
    final note = _noteCtrl.text.trim();
    final amount = double.tryParse(_amountCtrl.text.trim());

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter bazaar name")),
      );
      return;
    }
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid amount")),
      );
      return;
    }

    context.read<BazaarBloc>().add(BazaarAdd(name: name, amount: amount, note: note));
    context.pop(); 
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ProjectColor.whiteColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: 14),
              const Text("Add Bazaar",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),

              _field(
                controller: _nameCtrl,
                hint: "Bazaar name (e.g. Fish / Vegetables)",
                onChanged: (v) => context.read<BazaarBloc>().add(BazaarSuggestionsQuery(v)),
              ),

              BlocBuilder<BazaarBloc, BazaarState>(
                builder: (context, state) {
                  final s = state.suggestions
                      .where((e) => e.toLowerCase() != _nameCtrl.text.trim().toLowerCase())
                      .toList();

                  if (s.isEmpty || _nameCtrl.text.trim().isEmpty) return const SizedBox();

                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      color: ProjectColor.lavenderPurple.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: ProjectColor.lavenderPurple.withOpacity(0.25)),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: s.length,
                      itemBuilder: (_, i) {
                        return ListTile(
                          dense: true,
                          title: Text(s[i], style: const TextStyle(fontWeight: FontWeight.w800)),
                          onTap: () {
                            _nameCtrl.text = s[i];
                            setState(() {});
                          },
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),
              _field(
                controller: _amountCtrl,
                hint: "Amount",
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _field(
                controller: _noteCtrl,
                hint: "Note (optional)",
                lines: 2,
              ),
              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: InkWell(
                  onTap: _save,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ProjectColor.lavenderPurple.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: ProjectColor.lavenderPurple.withOpacity(0.28)),
                    ),
                    child: const Center(
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: ProjectColor.blackColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    int lines = 1,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      minLines: lines,
      maxLines: lines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }
}
