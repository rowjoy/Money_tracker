
import 'package:flutter/material.dart';

import '../../../../utilis/colors.dart';

class MorningMessage extends StatelessWidget {
  const MorningMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
              Text("Hello!",
                style: TextStyle(
                   color: ProjectColor.blackColor,
                   fontWeight: FontWeight.bold,
                   fontSize: 20,
                ),
              ),
              Text("Good morning",
                style: TextStyle(
                   color: ProjectColor.grey,
                   fontWeight: FontWeight.normal,
                   letterSpacing: 1.0,
                   fontSize: 15,
                ),
              )
           ],
        ),
        // Container(
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(50),
        //     gradient: LinearGradient(
        //       end: Alignment.topLeft,
        //       begin: Alignment.bottomRight,
        //       colors: ListColorCode.colorset1,
        //     ),
        //   ),
        //   child: Padding(
        //     padding: const EdgeInsets.all(12.0),
        //     child: Icon(Icons.person, color: ProjectColor.whiteColor),
        //   ),
        // ), 

        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            // ✅ DailyNote + Settings style (soft card + border)
            color: ProjectColor.lavenderPurple.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ProjectColor.lavenderPurple.withOpacity(0.25),
            ),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                offset: Offset(0, 8),
                color: Color(0x0F000000),
              ),
            ],
          ),
          child: Icon(
            Icons.person_outline,
            color: ProjectColor.electricPurple,
            size: 24,
          ),
        )

        
       ],
    );
  }
}