


// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:moneytracker/bloc/dashboard_bloc/dash_bloc.dart';
import 'package:moneytracker/bloc/dashboard_bloc/dash_event.dart';
import 'package:moneytracker/bloc/dashboard_bloc/dash_state.dart';

import 'package:moneytracker/data/enum.dart';
import 'package:moneytracker/utilis/assets_path.dart';
import 'package:moneytracker/utilis/colors.dart';

import 'package:moneytracker/views/dashboard/home/home_view.dart';
import 'package:moneytracker/views/dashboard/note/note_view.dart';
import 'package:moneytracker/views/dashboard/qr_code/qr_code_view.dart';
import 'package:moneytracker/views/dashboard/setting/setting_view.dart';

class DashBordView extends StatelessWidget {
  DashBordView({super.key});

  final List<Widget> viewList = [
    HomeView(),
    NoteView(),
    QrCodeView(),
    SettingView(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashBoardBloc, DashBoardState>(
      builder: (context, state) {
        return Scaffold(
          extendBody: true, // ✅ nice floating nav
          extendBodyBehindAppBar: true,
          backgroundColor: ProjectColor.whiteColor,

          body: viewList[state.activeIndex],

          bottomNavigationBar: PremiumBottomNav(activeIndex: state.activeIndex),
        );
      },
    );
  }
}

class PremiumBottomNav extends StatelessWidget {
  final int activeIndex;
  const PremiumBottomNav({super.key, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    // ✅ Similar feel to DailyNote/Settings cards
    final navBg = ProjectColor.lavenderPurple.withOpacity(0.06);
    final navBorder = ProjectColor.lavenderPurple.withOpacity(0.25);
    final activeColor = ProjectColor.electricPurple;
    final inactiveColor = ProjectColor.grey;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: navBg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: navBorder),
            boxShadow: const [
              BoxShadow(
                blurRadius: 14,
                offset: Offset(0, 10),
                color: Color(0x12000000),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PremiumNavItem(
                isActive: activeIndex == BaseNav.homeView.index,
                label: "Home",
                iconPath: IconsPath.homeIcon,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => context
                    .read<DashBoardBloc>()
                    .add(DeshBoardChanged(BaseNav.homeView.index)),
              ),
              PremiumNavItem(
                isActive: activeIndex == BaseNav.noteView.index,
                label: "Notes",
                iconPath: IconsPath.noteIcon,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => context
                    .read<DashBoardBloc>()
                    .add(DeshBoardChanged(BaseNav.noteView.index)),
              ),
              PremiumNavItem(
                isActive: activeIndex == BaseNav.qrcodeView.index,
                label: "Scan",
                iconPath: IconsPath.qrcodeIcon,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => context
                    .read<DashBoardBloc>()
                    .add(DeshBoardChanged(BaseNav.qrcodeView.index)),
              ),
              PremiumNavItem(
                isActive: activeIndex == BaseNav.settingView.index,
                label: "Settings",
                iconPath: IconsPath.settingIcon,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => context
                    .read<DashBoardBloc>()
                    .add(DeshBoardChanged(BaseNav.settingView.index)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PremiumNavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const PremiumNavItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Active pill same style as cards
    final activeBg = ProjectColor.lavenderPurple.withOpacity(0.10);
    final activeBorder = ProjectColor.lavenderPurple.withOpacity(0.30);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: activeColor.withOpacity(0.10),
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 12 : 10,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isActive ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isActive ? Border.all(color: activeBorder) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(
                isActive ? activeColor : inactiveColor,
                BlendMode.srcIn,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: SizedBox(width: isActive ? 8 : 0),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: isActive
                  ? Text(
                      label,
                      key: ValueKey(label),
                      style: TextStyle(
                        color: activeColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 0.3,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
