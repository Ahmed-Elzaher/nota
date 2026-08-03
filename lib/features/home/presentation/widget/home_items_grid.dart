import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nota/features/items/presentation/widget/item_card.dart';
import 'package:nota/features/items/domain/entity/item_entity.dart';
import 'package:nota/features/items/presentation/controller/items_cubit.dart';
import 'package:nota/features/items/presentation/screen/item_details_screen.dart';
import 'package:nota/features/home/presentation/widget/empty_notes_widget.dart';

class HomeItemsGrid extends StatelessWidget {
  final List<ItemEntity> items;

  const HomeItemsGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const EmptyNotesWidget();
    }

    return MasonryGridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 8.h,
        bottom: 100.h,
      ),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 12.w,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ItemCard(
          item: item,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<ItemsCubit>(),
                  child: ItemDetailsScreen(item: item),
                ),
              ),
            );
          },
          onDelete: () {
            context.read<ItemsCubit>().deleteItem(item.id);
          },
        );
      },
    );
  }
}
