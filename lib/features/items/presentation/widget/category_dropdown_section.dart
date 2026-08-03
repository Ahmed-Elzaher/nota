import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nota/core/utils/extensions/l10n_extension.dart';
import 'package:nota/core/theme/app_colors.dart';

class CategoryDropdownSection extends StatelessWidget {
  final String selectedCategory;
  final List<String> categories;
  final bool isCustomCategory;
  final TextEditingController customCategoryController;
  final ValueChanged<String> onCategoryChanged;

  const CategoryDropdownSection({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.isCustomCategory,
    required this.customCategoryController,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          initialValue: selectedCategory,
          decoration: const InputDecoration(
            hintText: 'Category', // will be overwritten by l10n below
            prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedFolder01, color: AppColors.iconGrey, size: 18),
          ).copyWith(hintText: context.l10n.category),
          items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (val) {
            if (val != null) {
              onCategoryChanged(val);
            }
          },
        ),
        if (isCustomCategory) ...[
          SizedBox(height: 12.h),
          TextField(
            controller: customCategoryController,
            decoration: InputDecoration(
              hintText: context.l10n.typeNewCategoryName,
              prefixIcon: const HugeIcon(icon: HugeIcons.strokeRoundedFolderAdd, color: AppColors.iconGrey, size: 18),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
