import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneytracker/bloc/home_bloc/wallet_state.dart';
import 'package:moneytracker/utilis/helpers.dart';

import '../../../../utilis/assets_path.dart';
import '../../../../utilis/colors.dart';

class BalanceCard extends StatelessWidget {
  final WalletState state;

  const BalanceCard({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ DailyNote + Settings style
    final bg = ProjectColor.lavenderPurple.withOpacity(0.06);
    final border = ProjectColor.lavenderPurple.withOpacity(0.25);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border),
        boxShadow: const [
          BoxShadow(
            blurRadius: 12,
            offset: Offset(0, 10),
            color: Color(0x10000000),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      SvgImagesPath.walletIcon,
                      width: 26,
                      height: 26,
                      colorFilter: const ColorFilter.mode(
                        ProjectColor.electricPurple,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Wallet Balance",
                        style: TextStyle(
                          color: ProjectColor.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Updated: ${Helpers.formatIsoToDate(DateTime.now().toIso8601String())}",
                        style: TextStyle(
                          color: ProjectColor.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Optional small badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Text(
                    "Live",
                    style: TextStyle(
                      color: ProjectColor.electricPurple,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Balance
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "\$${state.balance.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: ProjectColor.blackColor,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.2,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Income/Expense row (same card style like settings tiles)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _MiniStat(
                      title: "Expense",
                      value: state.totalExpense,
                      icon: Icons.arrow_upward_rounded,
                      iconColor: Colors.red,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 46,
                    color: Colors.black12,
                  ),
                  Expanded(
                    child: _MiniStat(
                      title: "Income",
                      value: state.totalIncome,
                      icon: Icons.arrow_downward_rounded,
                      iconColor: ProjectColor.electricPurple,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String title;
  final double value;
  final IconData icon;
  final Color iconColor;

  const _MiniStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ProjectColor.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "\$${value.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: ProjectColor.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
