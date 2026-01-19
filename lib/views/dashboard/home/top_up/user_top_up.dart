import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneytracker/widget/app_button.dart';

import '../../../../bloc/home_bloc/wallet_bloc.dart';
import '../../../../bloc/home_bloc/wallet_event.dart';
import '../../../../utilis/colors.dart';
import '../../../../widget/custom_appber.dart';
import '../../../../widget/header_card_view.dart';

class UserTopUp extends StatelessWidget {
  const UserTopUp({super.key});

  @override
  Widget build(BuildContext context) {
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: ProjectColor.whiteColor,
      appBar: CustomAppBer(title: "User Top Up"),
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
                  title: "Top Up Wallet",
                  subtitle: "Enter amount and add a note to save the transaction.",
                  icon: Icons.account_balance_wallet_outlined,
                  dgColor: Colors.grey.shade100,
                  borderColor: Colors.grey.shade200,
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
                    hintText: "e.g. 500",
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
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: "e.g. Salary / Gift / Saving",
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
                      // ✅ Put your bloc/repo call here:
                      context.read<WalletBloc>().add(WalletAddRequested(amount, note));

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Saved: $amount | $note")),
                    );

                  }, 
                  title: "Done", 
                ),
              

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
