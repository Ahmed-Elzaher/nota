import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nota/core/utils/extensions/l10n_extension.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.map, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Fake Mind Map visualization
            _buildMindMapNode(context, context.l10n.catIdeas, HugeIcons.strokeRoundedIdea, isMain: true),
            _buildVerticalLine(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMindMapNode(context, context.l10n.catProjects, HugeIcons.strokeRoundedBriefcase02),
                _buildHorizontalLine(context),
                _buildMindMapNode(context, context.l10n.catStudy, HugeIcons.strokeRoundedBook02),
                _buildHorizontalLine(context),
                _buildMindMapNode(context, context.l10n.catProgramming, HugeIcons.strokeRoundedCodeCircle),
              ],
            ),
            SizedBox(height: 40.h),
            Text(
              // "جاري بناء الخريطة الذهنية"
              'جاري بناء الخريطة الذهنية...',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              // "ستتمكن قريباً من ربط أفكارك ببعضها"
              'ستتمكن قريباً من ربط أفكارك ببعضها',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMindMapNode(BuildContext context, String title, List<List<dynamic>> icon, {bool isMain = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isMain ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isMain ? Colors.transparent : Theme.of(context).primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HugeIcon(
            icon: icon,
            color: isMain ? Colors.white : Theme.of(context).primaryColor,
            size: isMain ? 32.sp : 24.sp,
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              color: isMain ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: FontWeight.bold,
              fontSize: isMain ? 14.sp : 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalLine(BuildContext context) {
    return Container(
      width: 2.w,
      height: 30.h,
      color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
    );
  }

  Widget _buildHorizontalLine(BuildContext context) {
    return Container(
      width: 20.w,
      height: 2.h,
      color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
    );
  }
}
