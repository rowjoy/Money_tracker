import 'package:flutter/material.dart';
import 'package:moneytracker/utilis/colors.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final bool loading;

  const AppButton({
    super.key,
    required this.onTap,
    required this.title,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: loading ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: ProjectColor.electricPurple.withOpacity(0.10),
        highlightColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: ProjectColor.lavenderPurple.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ProjectColor.lavenderPurple.withOpacity(0.28),
            ),
            boxShadow: const [
              BoxShadow(
                blurRadius: 12,
                offset: Offset(0, 8),
                color: Color(0x10000000),
              ),
            ],
          ),
          child: Center(
            child: loading
                ? SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ProjectColor.electricPurple,
                    ),
                  )
                : Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: ProjectColor.blackColor,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
