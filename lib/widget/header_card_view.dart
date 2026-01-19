
import 'package:flutter/material.dart';

class HeaderCardView extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color dgColor;
  final Color borderColor;
  const HeaderCardView({
    
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.dgColor,
    required this.borderColor,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Icon(Icons.account_balance_wallet_outlined),
          ),
          const SizedBox(width: 12),
           Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
