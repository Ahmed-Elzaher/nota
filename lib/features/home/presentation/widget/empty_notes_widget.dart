import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nota/core/utils/extensions/l10n_extension.dart';

class EmptyNotesWidget extends StatelessWidget {
  const EmptyNotesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.3),
        HugeIcon(
          icon: HugeIcons.strokeRoundedFolder01,
          color: Theme.of(context).disabledColor,
          size: 60.sp,
        ),
        SizedBox(height: 16.h),
        Center(
          child: Text(
            context.l10n.noItemsInThisCategory,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey[600],
              fontSize: 16.sp,
            ),
          ),
        ),
      ],
    );
  }
}
