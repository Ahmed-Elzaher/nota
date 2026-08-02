import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nota/core/utils/extensions/l10n_extension.dart';
import 'package:nota/features/items/presentation/controller/items_cubit.dart';

class CategoryTabsWidget extends StatelessWidget {
  const CategoryTabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultCategories = [
      context.l10n.catAll,
      context.l10n.catProgramming,
      context.l10n.catProjects,
      context.l10n.catStudy,
      context.l10n.catIdeas,
      context.l10n.catOther,
    ];
    final itemsCubit = context.watch<ItemsCubit>();
    final customCategories = itemsCubit.uniqueCategories;
    final categories = [...defaultCategories, ...customCategories];
    
    final currentCat = itemsCubit.currentCategory;

    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat == currentCat;
          return ChoiceChip(
            label: Text(cat),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                context.read<ItemsCubit>().filterByCategory(cat);
              }
            },
            selectedColor: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).cardColor,
            elevation: 0,
            pressElevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).dividerColor,
                width: 1,
              ),
            ),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          );
        },
      ),
    );
  }
}
