
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moneytracker/bloc/home_bloc/wallet_state.dart';
import 'package:moneytracker/utilis/assets_path.dart';
import 'package:moneytracker/widget/transction_card_view.dart';

import '../../../../route/page_path.dart';
import '../../../../utilis/colors.dart';

class Transctions extends StatelessWidget {
  final  WalletState state;
  const Transctions({
    super.key,
    required this.state
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        // color: ProjectColor.lavenderPurple.withOpacity(0.06),
       // borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
           children: [
              Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text("Transctions",
                     style: TextStyle(
                       color: ProjectColor.blackColor,
                       fontSize: 18,
                       fontWeight: FontWeight.w800,
                     ),
                   ),
                   InkWell(
                     onTap: () {
                       context.push(PagePath.allTransctionList);
                     },
                     child: Text("See all",
                      style: TextStyle(
                         color: ProjectColor.grey,
                         fontSize: 14,
                         fontWeight: FontWeight.normal,
                         letterSpacing: 1.0,
                       ),
                     ),
                   ),
                 ],
              ),
              SizedBox(height: 20),
              ListView.builder(
                itemCount: state.transactions.length > 5 ? 5 : state.transactions.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (_, index){
                final t = state.transactions[index];
                final type = (t['type'] ?? '').toString();
                final note = (t['note'] ?? '').toString();
                final amount = (t['amount'] as num).toDouble();
                final createdAt = (t['created_at'] ?? '').toString();
                final isAdd = type == 'ADD';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TransctionCardView(isAdd: isAdd, note: note, createdAt: createdAt, amount: amount),
                );
                }
              ),
           ],
        ),
      ),
    );
  }
}


