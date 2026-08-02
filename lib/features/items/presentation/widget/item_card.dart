import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nota/features/items/data/model/item_model.dart';
import 'package:any_link_preview/any_link_preview.dart';

class ItemCard extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const ItemCard({
    super.key,
    required this.item,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUrl = item.type == 'url';
    final hasImage = item.imageUrl != null && item.imageUrl!.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h), // Replaced Card margin with Container margin for Masonry
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. Link Preview (if URL)
                if (isUrl)
                  AbsorbPointer(
                    child: AnyLinkPreview(
                      link: item.content,
                      displayDirection: UIDirection.uiDirectionVertical,
                      cache: const Duration(days: 7),
                      backgroundColor: Theme.of(context).cardColor,
                      errorWidget: Container(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
                        padding: EdgeInsets.all(12.w),
                        child: Row(
                          children: [
                            Icon(Icons.link, color: Theme.of(context).primaryColor),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                item.content,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // 3. Content Area
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Category and Delete
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                item.category,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            onTap: onDelete,
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: HugeIcon(
                                icon: HugeIcons.strokeRoundedDelete01,
                                color: Colors.redAccent,
                                size: 18.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 12.h),
                      
                      // Note Content
                      if (!isUrl || (isUrl && item.tags != null && item.tags!.isNotEmpty))
                        Text(
                          item.content,
                          maxLines: 8, // Flexible up to 8 lines!
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black87,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      
                      // Thumbnail Image
                      if (hasImage) ...[
                        SizedBox(height: 12.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.file(
                            File(item.imageUrl!),
                            width: 60.w,
                            height: 60.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],

                      // Tags
                      if (item.tags != null && item.tags!.isNotEmpty) ...[
                        SizedBox(height: 12.h),
                        Wrap(
                          spacing: 6.w,
                          runSpacing: 6.h,
                          children: item.tags!.split(',').map((tag) {
                            final t = tag.trim();
                            if (t.isEmpty) return const SizedBox();
                            return Text(
                              '#$t',
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
