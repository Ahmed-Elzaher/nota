import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nota/core/di/di.dart';
import 'package:nota/core/router/router_path.dart';
import 'package:nota/core/services/notification_service.dart';
import 'package:nota/core/utils/extensions/l10n_extension.dart';
import 'package:nota/features/home/presentation/widget/category_tabs_widget.dart';
import 'package:nota/features/home/presentation/widget/home_items_grid.dart';
import 'package:nota/features/items/presentation/controller/items_cubit.dart';
import 'package:nota/features/items/presentation/controller/items_state.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<ItemsCubit>()..fetchItems(),
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
    _intentDataStreamSubscription = ReceiveSharingIntent.instance
        .getMediaStream()
        .listen(
          (List<SharedMediaFile> value) {
            if (value.isNotEmpty) {
              _handleSharedData(value.first.path);
            }
          },
          onError: (err) {
            debugPrint("getIntentDataStream error: $err");
          },
        );

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.instance.getInitialMedia().then((
      List<SharedMediaFile> value,
    ) {
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
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedIdea,
                  color: Colors.yellow,
                  size: 24,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    tip,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
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
    // Delay to ensure the UI is fully built before navigating
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      Navigator.pushNamed(context, RouterPath.addItem, arguments: data);
    });
  }

  void _showAddSheet() {
    Navigator.pushNamed(context, RouterPath.addItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedNotification01,
            color: Theme.of(context).iconTheme.color ?? Colors.black87,
            size: 24,
          ),
          onPressed: () {
            Navigator.pushNamed(context, RouterPath.notifications);
          },
        ),
        title: Text(
          context.l10n.appName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedSettings01,
              color: Theme.of(context).iconTheme.color ?? Colors.black87,
              size: 24,
            ),
            onPressed: () {
              Navigator.pushNamed(context, RouterPath.settings);
            },
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              height: 48.h,
              child: TextField(
                onChanged: (query) {
                  context.read<ItemsCubit>().searchItems(query);
                },
                decoration: InputDecoration(
                  hintText: context.l10n.searchHint,
                  hintStyle: const TextStyle(fontSize: 14),
                  prefixIcon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedSearch02,
                    color: Colors.grey,
                    size: 16,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 16.w,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: Colors.grey.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          const CategoryTabsWidget(),
          SizedBox(height: 8.h),
          Expanded(
            child: BlocConsumer<ItemsCubit, ItemsState>(
              listener: (context, state) {
                if (state is ItemsError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.failure.message, style: const TextStyle(color: Colors.white)),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ItemsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } 
                
                // Get items either from ItemsLoaded or fallback to cubit cache
                final items = (state is ItemsLoaded) 
                    ? state.items 
                    : context.read<ItemsCubit>().allItems;

                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<ItemsCubit>().fetchItems();
                  },
                  child: HomeItemsGrid(items: items),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 80.h,
        ),
        child: FloatingActionButton(
          heroTag: 'home_fab',
          onPressed: _showAddSheet,
          child: const HugeIcon(
            icon: HugeIcons.strokeRoundedAdd01,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
