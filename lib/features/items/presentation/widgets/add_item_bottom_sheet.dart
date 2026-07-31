import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nota/features/items/data/models/item_model.dart';
import 'package:nota/features/items/presentation/manager/items_cubit.dart';

class AddItemBottomSheet extends StatefulWidget {
  final String? initialContent;
  const AddItemBottomSheet({super.key, this.initialContent});

  @override
  State<AddItemBottomSheet> createState() => _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends State<AddItemBottomSheet> {
  late final TextEditingController _contentController;
  final _tagsController = TextEditingController();
  String _selectedType = 'text'; // 'text' or 'url'
  String _selectedCategory = 'أخرى';
  final List<String> _categories = ['أخرى', 'برمجة', 'مشاريع', 'دراسة', 'أفكار'];

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.initialContent ?? '');
    if (widget.initialContent != null && (widget.initialContent!.startsWith('http://') || widget.initialContent!.startsWith('https://'))) {
      _selectedType = 'url';
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _saveItem() {
    final content = _contentController.text.trim();
    if (content.isEmpty) return;

    // Simple URL validation
    if (_selectedType == 'text' && (content.startsWith('http://') || content.startsWith('https://'))) {
      _selectedType = 'url';
    }

    final newItem = ItemModel(
      type: _selectedType,
      content: _contentController.text,
      tags: _tagsController.text,
      category: _selectedCategory,
      createdAt: DateTime.now().toIso8601String(),
    );

    context.read<ItemsCubit>().addItem(newItem);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20.w,
        right: 20.w,
        top: 20.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add New Item',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'text', icon: Icon(Icons.notes), label: Text('Note')),
              ButtonSegment(value: 'url', icon: Icon(Icons.link), label: Text('Link')),
            ],
            selected: {_selectedType},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _selectedType = newSelection.first;
              });
            },
          ),
          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            decoration: const InputDecoration(labelText: 'القسم'),
            items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedCategory = val);
            },
          ),
          SizedBox(height: 16.h),
          TextField(
            controller: _contentController,
            maxLines: _selectedType == 'text' ? 4 : 1,
            decoration: InputDecoration(
              hintText: _selectedType == 'text' ? 'Write your note here...' : 'Paste link here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _tagsController,
            decoration: InputDecoration(
              hintText: 'Tags (comma separated)',
              prefixIcon: const Icon(Icons.tag),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: _saveItem,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Save',
              style: TextStyle(fontSize: 16.sp),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
