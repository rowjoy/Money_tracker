// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moneytracker/route/page_path.dart';
import 'package:moneytracker/utilis/colors.dart';


class QuickActionsGrid extends StatelessWidget {
  QuickActionsGrid({super.key});

  final List<_ActionItem> _items = [
    _ActionItem(
      id: 1,
      label: 'Add Income',
      icon: Icons.add_circle_outline,
      route: PagePath.userTopUp,
    ),
    _ActionItem(
      id : 2,
      label: 'Cash Out',
      icon: Icons.account_balance_wallet_outlined,
      route:PagePath.userCashOut
    ),
    _ActionItem(
      id: 3,
      label: 'Bg Cleaner',
      icon: Icons.image_outlined,
      route: PagePath.bgRemoverView,
    ),
    _ActionItem(
      id: 4,
      label: 'Insights',
      icon: Icons.bar_chart_outlined,
      route: ""
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90, // height for one row of boxes
      child: GridView.builder(
        scrollDirection: Axis.horizontal, // horizontal grid
        itemCount: _items.length,
        
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,        // 1 line
          mainAxisSpacing: 12,      // space between boxes (left-right)
          childAspectRatio: 1,      // square-ish cards
        ),
        itemBuilder: (context, index) {
          final item = _items[index];
          return _ActionCard(item: item,);
        },
      ),
    );
  }
}

class _ActionItem {
  final int id;
  final String label;
  final IconData icon;
  final String route;

  _ActionItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.route,
  });
}


class _ActionCard extends StatelessWidget {
  final _ActionItem item;
  final void Function()? onTap;

  const _ActionCard({
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = ProjectColor.lavenderPurple.withOpacity(0.06);
    final border = ProjectColor.lavenderPurple.withOpacity(0.25);

    return InkWell(
      onTap: onTap ?? () => context.push(item.route),
      borderRadius: BorderRadius.circular(16),
      splashColor: ProjectColor.electricPurple.withOpacity(0.10),
      highlightColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              offset: Offset(0, 8),
              color: Color(0x0F000000),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // ✅ if card is small, hide subtitle to prevent overflow
            final isSmall = constraints.maxHeight < 110;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Icon(
                    item.icon,
                    size: 22,
                    color: ProjectColor.electricPurple,
                  ),
                ),
                const SizedBox(height: 8),

                // ✅ Flexible text (no overflow)
                Flexible(
                  child: Text(
                    item.label,
                    textAlign: TextAlign.center,
                    maxLines: isSmall ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: ProjectColor.blackColor,
                      height: 1.15,
                    ),
                  ),
                ),

                // ✅ Only show subtitle when enough height
                if (!isSmall) ...[
                  const SizedBox(height: 6),
                  Text(
                    "Tap to open",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: ProjectColor.grey,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}


