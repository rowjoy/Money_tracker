// ignore_for_file: prefer_interpolation_to_compose_strings, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneytracker/utilis/helpers.dart';
import 'package:moneytracker/widget/header_card_view.dart';
import 'package:moneytracker/widget/transction_card_view.dart';

import '../../../../bloc/home_bloc/wallet_bloc.dart';
import '../../../../bloc/home_bloc/wallet_state.dart';
import '../../../../utilis/assets_path.dart';
import '../../../../utilis/colors.dart';
import '../../../../widget/custom_appber.dart';

/// ✅ NEW PAGE: See all transactions (nice UI)
class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColor.whiteColor,
      appBar: CustomAppBer(title: "All Transactions"),
      body: SafeArea(
        child: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.transactions.isEmpty) {
              return Center(
                child: Text(
                  "No transactions yet",
                  style: TextStyle(color: ProjectColor.grey),
                ),
              );
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: HeaderCardView(
                    title: "Transaction History",
                    subtitle: "You have " +
                        state.transactions.length.toString() +
                        " transactions",
                    icon: Icons.history,
                    dgColor: Colors.blue.shade50,
                    borderColor: Colors.blue.shade100,
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.transactions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final t = state.transactions[index];
                      final type = (t['type'] ?? '').toString();
                      final note = (t['note'] ?? '').toString();
                      final amount = (t['amount'] as num).toDouble();
                      final createdAt = (t['created_at'] ?? '').toString();
                  
                      final isAdd = type == 'ADD';
                  
                      return TransctionCardView(isAdd: isAdd, note: note, createdAt: createdAt, amount: amount);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}




