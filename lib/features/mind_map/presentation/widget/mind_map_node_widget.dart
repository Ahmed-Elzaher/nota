import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nota/core/theme/app_colors.dart';
import 'package:nota/core/theme/font_styles.dart';
import 'package:nota/features/mind_map/domain/entity/mind_map_entity.dart';

class MindMapNodeWidget extends StatelessWidget {
  final MapNode node;
  final ValueChanged<String> onTextChanged;
  final bool isSelected;
  final VoidCallback onTap;

  const MindMapNodeWidget({
    super.key,
    required this.node,
    required this.onTextChanged,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color nodeColor = node.color != null 
        ? Color(int.parse(node.color!.replaceFirst('#', '0xFF')))
        : AppColors.surface;
        
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          minWidth: 100.w,
          maxWidth: 250.w,
          minHeight: 50.h,
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: nodeColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2.5 : 1.0,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 2,
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: IntrinsicWidth(
          child: TextFormField(
            initialValue: node.text,
            onChanged: onTextChanged,
            maxLines: null,
            textAlign: TextAlign.center,
            style: FontStyles.body.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: 'فكرة جديدة',
              hintStyle: FontStyles.body.copyWith(color: AppColors.textHint),
            ),
          ),
        ),
      ),
    );
  }
}
