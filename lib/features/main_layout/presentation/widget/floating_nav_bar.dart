import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nota/core/utils/extensions/l10n_extension.dart';
import 'package:nota/features/main_layout/presentation/controller/main_cubit.dart';

class FloatingNavBar extends StatelessWidget {
  const FloatingNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.watch<MainCubit>().state;

    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavBarItem(
              index: 0,
              currentIndex: currentIndex,
              icon: HugeIcons.strokeRoundedHome01,
              label: context.l10n.home,
            ),
            _NavBarItem(
              index: 1,
              currentIndex: currentIndex,
              icon: HugeIcons.strokeRoundedMaps,
              label: context.l10n.map,
            ),
            _NavBarItem(
              index: 2,
              currentIndex: currentIndex,
              icon: HugeIcons.strokeRoundedIdea,
              label: context.l10n.tips,
            ),
            _NavBarItem(
              index: 3,
              currentIndex: currentIndex,
              icon: HugeIcons.strokeRoundedMic01,
              label: context.l10n.voiceNotes,
            ),
            _NavBarItem(
              index: 4,
              currentIndex: currentIndex,
              icon: HugeIcons.strokeRoundedMoreHorizontalCircle01,
              label: context.l10n.soon,
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final dynamic icon;
  final String label;

  const _NavBarItem({
    required this.index,
    required this.currentIndex,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = currentIndex == index;
    final primaryColor = Theme.of(context).primaryColor;
    final unselectedColor = Theme.of(context).disabledColor;

    return GestureDetector(
      onTap: () => context.read<MainCubit>().changeTab(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 12.w : 6.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(
              icon: icon,
              color: isSelected ? primaryColor : unselectedColor,
              size: 24.sp,
            ),
            if (isSelected) ...[
              SizedBox(width: 8.w),
              Text(
                label,
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
