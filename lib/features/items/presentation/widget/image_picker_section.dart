import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nota/core/utils/extensions/l10n_extension.dart';
import 'package:nota/core/theme/app_colors.dart';

class ImagePickerSection extends StatelessWidget {
  final File? selectedImage;
  final ValueChanged<File?> onImageChanged;

  const ImagePickerSection({
    super.key,
    required this.selectedImage,
    required this.onImageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final picker = ImagePicker();

    if (selectedImage != null) {
      return Stack(
        children: [
          InkWell(
            onTap: () async {
              final XFile? image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                onImageChanged(File(image.path));
              }
            },
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.iconGrey.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(16.r),
                color: Theme.of(context).cardColor,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.file(selectedImage!, height: 100.h, width: 100.w, fit: BoxFit.cover),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    context.l10n.changeImage,
                    style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8.h,
            right: 8.w,
            child: IconButton(
              onPressed: () {
                onImageChanged(null);
              },
              icon: const HugeIcon(icon: HugeIcons.strokeRoundedDelete01, color: AppColors.iconWhite, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.error.withValues(alpha: 0.8),
                padding: const EdgeInsets.all(8),
              ),
            ),
          ),
        ],
      );
    }

    return InkWell(
      onTap: () async {
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          onImageChanged(File(image.path));
        }
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.iconGrey.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(16.r),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          children: [
            HugeIcon(icon: HugeIcons.strokeRoundedImage01, color: Theme.of(context).primaryColor, size: 28),
            SizedBox(height: 8.h),
            Text(
              context.l10n.addImage,
              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
