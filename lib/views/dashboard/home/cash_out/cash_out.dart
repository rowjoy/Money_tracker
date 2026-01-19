import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneytracker/bloc/home_bloc/wallet_event.dart';
import 'package:moneytracker/views/dashboard/home/top_up/user_top_up.dart';
import 'package:moneytracker/widget/app_button.dart';
import 'package:moneytracker/widget/header_card_view.dart';

import '../../../../bloc/home_bloc/wallet_bloc.dart';
import '../../../../utilis/colors.dart';
import '../../../../widget/custom_appber.dart';

class UserCashOut extends StatelessWidget {
  const UserCashOut({super.key});

  @override
  Widget build(BuildContext context) {
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: ProjectColor.whiteColor,
      appBar: CustomAppBer(title: "Cash Out"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header card
                HeaderCardView(
                  title: "Cash Out",
                  subtitle: "Withdraw money from your wallet.",
                  icon: Icons.arrow_upward_rounded,
                  dgColor: Colors.red.shade50,
                  borderColor: Colors.red.shade100
                ),
                const SizedBox(height: 18),

                const Text(
                  "Amount",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: amountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: "e.g. 300",
                    prefixIcon: const Icon(Icons.payments_outlined),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(width: 1.4),
                    ),
                  ),
                  validator: (v) {
                    final t = (v ?? "").trim();
                    if (t.isEmpty) return "Enter amount";
                    final n = double.tryParse(t);
                    if (n == null) return "Enter valid number";
                    if (n <= 0) return "Amount must be greater than 0";
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                const Text(
                  "Note",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: noteCtrl,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: "e.g. Rent / Shopping / Food",
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Icon(Icons.edit_note_outlined),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(width: 1.4),
                    ),
                  ),
                  validator: (v) {
                    if ((v ?? "").trim().isEmpty) return "Write a note";
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppButton(
                  onTap: (){
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (!formKey.currentState!.validate()) return;

                    final amount = double.parse(amountCtrl.text.trim());
                    final note = noteCtrl.text.trim();

                    // ✅ Bloc / repository call:
                    context.read<WalletBloc>().add(WalletCashOutRequested(amount, note));

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Cash out: $amount | $note")),
                    );
                  }, 
                  title: "Cash Out",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
