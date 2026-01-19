
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneytracker/utilis/assets_path.dart';
import 'package:moneytracker/utilis/colors.dart';
import 'package:moneytracker/utilis/helpers.dart';

class TransctionCardView extends StatelessWidget {
  const TransctionCardView({
    super.key,
    required this.isAdd,
    required this.note,
    required this.createdAt,
    required this.amount,
  });

  final bool isAdd;
  final String note;
  final String createdAt;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ProjectColor.lavenderPurple.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ProjectColor.lavenderPurple.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.55,
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      width: 1,
                      color: ProjectColor.lavenderPurple.withOpacity(0.6),
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      isAdd ? SvgImagesPath.addMoney : SvgImagesPath.outmoney,
                      width: 22,
                      height: 22,
                      colorFilter: ColorFilter.mode(
                        isAdd ? ProjectColor.electricPurple : Colors.red,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.isEmpty ? (isAdd ? "Top up" : "Cash out") : note,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ProjectColor.blackColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      // _formatIsoToDate(createdAt),
                      Helpers.formatIsoToDate(createdAt),
                      style: TextStyle(
                        color: ProjectColor.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                (isAdd ? "+ " : "- ") + "\$${amount.toStringAsFixed(2)}",
                style: TextStyle(
                  color: isAdd ? ProjectColor.blackColor : Colors.red,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Container(
               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.black12),
                ),
                child: Text(
                  isAdd ? "ADD" : "CASH OUT",
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 0.8,
                    color: ProjectColor.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          )
          
        ],
      ),
    );
  }
}