// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneytracker/bloc/home_bloc/wallet_bloc.dart';
import 'package:moneytracker/bloc/home_bloc/wallet_state.dart';
import 'package:moneytracker/utilis/colors.dart';
import 'package:moneytracker/views/dashboard/home/component/balance_card.dart';
import 'package:moneytracker/views/dashboard/home/component/morning_message.dart';
import 'package:moneytracker/views/dashboard/home/component/quick_actiongrid.dart';
import 'package:moneytracker/views/dashboard/home/component/transctions_card_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(left: 15,right: 15),
      child: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
               decoration: BoxDecoration(
                 color: ProjectColor.whiteColor,
               ),
               child: Column(
                 children: [
                    MorningMessage(),
                    SizedBox(height: 20),
                    BalanceCard(state: state),
                    SizedBox(height: 15),
                    QuickActionsGrid(),
                    SizedBox(height: 15),
                    Transctions(state: state),
                 ],
               ),
            ),
          );
        }
      ),
    );
  }
}
