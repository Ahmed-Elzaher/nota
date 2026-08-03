import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:nota/features/items/domain/entity/item_entity.dart';
import 'package:nota/features/items/presentation/controller/items_cubit.dart';
import 'package:nota/core/utils/extensions/l10n_extension.dart';
import 'package:nota/core/theme/app_colors.dart';
import 'package:nota/features/items/presentation/widget/image_picker_section.dart';
import 'package:nota/features/items/presentation/widget/category_dropdown_section.dart';

class AddItemScreen extends StatefulWidget {
  final String? initialContent;
  const AddItemScreen({super.key, this.initialContent});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  late final TextEditingController _contentController;
  final _tagsController = TextEditingController();
  String _selectedType = 'text';
  late String _selectedCategory;
  late final List<String> _categories;
  final TextEditingController _customCategoryController = TextEditingController();
  bool _isCustomCategory = false;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.initialContent ?? '');
    if (widget.initialContent != null && (widget.initialContent!.startsWith('http://') || widget.initialContent!.startsWith('https://'))) {
      _selectedType = 'url';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _categories = [context.l10n.catOther, context.l10n.catProgramming, context.l10n.catProjects, context.l10n.catStudy, context.l10n.catIdeas, context.l10n.addNewCategory];
    _selectedCategory = context.l10n.catOther;
  }

  @override
  void dispose() {
    _contentController.dispose();
    _tagsController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  void _saveItem() {
    final content = _contentController.text.trim();
    if (content.isEmpty) return;

    if (_selectedType == 'text' && (content.startsWith('http://') || content.startsWith('https://'))) {
      _selectedType = 'url';
    }

    final newItem = ItemEntity(
      id: 0,
      type: _selectedType,
      content: _contentController.text,
      tags: _tagsController.text,
      category: _isCustomCategory ? _customCategoryController.text.trim() : _selectedCategory,
      imageUrl: _selectedImage?.path,
      createdAt: DateTime.now().toIso8601String(),
    );

    context.read<ItemsCubit>().addItem(newItem);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.addNewNote, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: _saveItem,
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedTick01,
              color: Theme.of(context).primaryColor,
              size: 28,
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Note Type Selection
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'text', icon: const HugeIcon(icon: HugeIcons.strokeRoundedText, color: AppColors.iconGrey, size: 20), label: Text(context.l10n.text)),
                ButtonSegment(value: 'url', icon: const HugeIcon(icon: HugeIcons.strokeRoundedLink01, color: AppColors.iconGrey, size: 20), label: Text(context.l10n.link)),
              ],
              selected: {_selectedType},
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  _selectedType = newSelection.first;
                });
              },
            ),
            SizedBox(height: 20.h),
            
            // Category Dropdown
            CategoryDropdownSection(
              selectedCategory: _selectedCategory,
              categories: _categories,
              isCustomCategory: _isCustomCategory,
              customCategoryController: _customCategoryController,
              onCategoryChanged: (val) {
                setState(() {
                  _selectedCategory = val;
                  _isCustomCategory = val == context.l10n.addNewCategory;
                });
              },
            ),
            SizedBox(height: 20.h),

            // Content Input
            TextField(
              controller: _contentController,
              maxLines: _selectedType == 'text' ? 12 : 2,
              minLines: _selectedType == 'text' ? 8 : 1,
              textInputAction: _selectedType == 'text' ? TextInputAction.newline : TextInputAction.done,
              keyboardType: _selectedType == 'text' ? TextInputType.multiline : TextInputType.url,
              decoration: InputDecoration(
                hintText: _selectedType == 'text' ? context.l10n.writeYourNoteHere : context.l10n.pasteLinkHere,
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Tags Input
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(
                hintText: context.l10n.tagsCommaSeparated,
                prefixIcon: const HugeIcon(icon: HugeIcons.strokeRoundedTag01, color: AppColors.iconGrey, size: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            
            // Image Picker Section
            ImagePickerSection(
              selectedImage: _selectedImage,
              onImageChanged: (file) {
                setState(() => _selectedImage = file);
              },
            ),
            SizedBox(height: 32.h),

            // Save Button
            ElevatedButton.icon(
              onPressed: _saveItem,
              icon: const HugeIcon(icon: HugeIcons.strokeRoundedFloppyDisk, color: Colors.white, size: 24),
              label: Text(context.l10n.save, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
