import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nota/core/di/di.dart';
import 'package:nota/core/router/router_path.dart';
import 'package:nota/core/theme/app_colors.dart';
import 'package:nota/core/theme/font_styles.dart';
import 'package:nota/features/mind_map/domain/entity/mind_map_entity.dart';
import 'package:nota/features/mind_map/presentation/controller/mind_maps_cubit.dart';
import 'package:nota/features/mind_map/presentation/controller/mind_maps_state.dart';
import 'package:intl/intl.dart';

class MindMapsListScreen extends StatelessWidget {
  const MindMapsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MindMapsCubit>()..fetchMindMaps(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          title: Text(
            'الخرائط الذهنية',
            style: FontStyles.h3.copyWith(color: AppColors.textPrimary),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocBuilder<MindMapsCubit, MindMapsState>(
          builder: (context, state) {
            if (state is MindMapsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MindMapsError) {
              return Center(
                child: Text(
                  state.failure.message,
                  style: FontStyles.body.copyWith(color: AppColors.error),
                ),
              );
            } else if (state is MindMapsLoaded) {
              final maps = state.mindMaps;
              if (maps.isEmpty) {
                return _buildEmptyState(context);
              }
              return _buildList(context, maps);
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 90.h),
          child: FloatingActionButton(
            heroTag: 'mind_maps_list_fab',
            onPressed: () {
              Navigator.pushNamed(context, RouterPath.mindMapEditor);
            },
            backgroundColor: AppColors.primary,
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedAdd01,
              color: AppColors.onPrimary,
              size: 24.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedBrain,
            color: AppColors.iconDisabled,
            size: 64.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            'لا توجد خرائط ذهنية بعد',
            style: FontStyles.h3.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 8.h),
          Text(
            'اضغط على الزر أدناه لإنشاء أول خريطة ذهنية لك',
            style: FontStyles.body.copyWith(color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<MindMapEntity> maps) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 120.h),
      itemCount: maps.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final mindMap = maps[index];
        return InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              RouterPath.mindMapEditor,
              arguments: mindMap,
            );
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                HugeIcon(
                  icon: HugeIcons.strokeRoundedBrain,
                  color: AppColors.primary,
                  size: 28.sp,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mindMap.title.isEmpty ? 'بدون عنوان' : mindMap.title,
                        style: FontStyles.h4.copyWith(color: AppColors.textPrimary),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        DateFormat('yyyy-MM-dd • hh:mm a', 'ar').format(DateTime.parse(mindMap.createdAt)),
                        style: FontStyles.caption.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedDelete01,
                    color: AppColors.error,
                    size: 24.sp,
                  ),
                  onPressed: () {
                    context.read<MindMapsCubit>().deleteMindMap(mindMap.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
