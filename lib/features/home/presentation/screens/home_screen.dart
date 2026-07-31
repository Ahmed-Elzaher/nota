import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nota/core/di/di.dart';
import 'package:nota/features/items/presentation/manager/items_cubit.dart';
import 'package:nota/features/items/presentation/manager/items_state.dart';
import 'package:nota/features/items/presentation/widgets/add_item_bottom_sheet.dart';
import 'package:nota/features/items/presentation/widgets/item_card.dart';
import 'package:nota/features/items/presentation/screens/item_details_screen.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:nota/core/services/notification_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ItemsCubit>()..fetchItems(),
      child: const _HomeScreenContent(),
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  const _HomeScreenContent();

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  StreamSubscription? _intentDataStreamSubscription;

  @override
  void initState() {
    super.initState();
    
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.instance.getMediaStream().listen((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        _handleSharedData(value.first.path);
      }
    }, onError: (err) {
      debugPrint("getIntentDataStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        _handleSharedData(value.first.path);
        ReceiveSharingIntent.instance.reset();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final tip = NotificationService.instance.getRandomTip();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.yellow),
                SizedBox(width: 8.w),
                Expanded(child: Text(tip, style: const TextStyle(fontWeight: FontWeight.bold))),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    super.dispose();
  }

  void _handleSharedData(String data) {
    // Delay to ensure the UI is fully built before showing the bottom sheet
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (_) {
          return BlocProvider.value(
            value: context.read<ItemsCubit>(),
            child: AddItemBottomSheet(initialContent: data),
          );
        },
      );
    });
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) {
        return BlocProvider.value(
          value: context.read<ItemsCubit>(),
          child: const AddItemBottomSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nota', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: TextField(
              onChanged: (query) {
                context.read<ItemsCubit>().searchItems(query);
              },
              decoration: InputDecoration(
                hintText: 'Search notes, links, tags...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 8.h),
          _buildCategoryTabs(context),
          Expanded(
            child: BlocBuilder<ItemsCubit, ItemsState>(
              builder: (context, state) {
                if (state is ItemsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ItemsError) {
                  return Center(child: Text(state.message));
                } else if (state is ItemsLoaded) {
                  if (state.items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 60.sp, color: Colors.grey[400]),
                          SizedBox(height: 16.h),
                          Text(
                            'لا يوجد عناصر في هذا القسم',
                            style: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
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
                          context.read<ItemsCubit>().deleteItem(int.parse(item.id.toString()));
                        },
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSheet,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context) {
    final categories = ['الكل', 'برمجة', 'مشاريع', 'دراسة', 'أفكار', 'أخرى'];
    final currentCat = context.watch<ItemsCubit>().currentCategory;

    return SizedBox(
      height: 40.h,
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
              if (selected) context.read<ItemsCubit>().filterByCategory(cat);
            },
            selectedColor: Theme.of(context).primaryColor,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          );
        },
      ),
    );
  }
}
