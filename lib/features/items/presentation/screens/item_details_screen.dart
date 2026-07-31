import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nota/features/items/data/models/item_model.dart';
import 'package:nota/features/items/presentation/manager/items_cubit.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nota/core/services/notification_service.dart';

class ItemDetailsScreen extends StatefulWidget {
  final ItemModel item;

  const ItemDetailsScreen({super.key, required this.item});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late TextEditingController _contentController;
  late TextEditingController _tagsController;
  late String _selectedCategory;

  final List<String> _categories = ['أخرى', 'برمجة', 'مشاريع', 'دراسة', 'أفكار'];

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.item.content);
    _tagsController = TextEditingController(text: (widget.item.tags != null && widget.item.tags!.isNotEmpty) ? widget.item.tags : '');
    _selectedCategory = widget.item.category;
    if (!_categories.contains(_selectedCategory)) {
      _categories.add(_selectedCategory);
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedItem = ItemModel(
      id: widget.item.id,
      type: widget.item.type,
      content: _contentController.text,
      title: widget.item.title,
      imageUrl: widget.item.imageUrl,
      tags: _tagsController.text,
      category: _selectedCategory,
      createdAt: widget.item.createdAt,
    );

    context.read<ItemsCubit>().updateItem(updatedItem);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ التعديلات بنجاح')),
    );
  }

  Future<void> _setReminder() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;
    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    final scheduledTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    
    if (scheduledTime.isBefore(DateTime.now())) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار وقت في المستقبل')));
      return;
    }

    await NotificationService.instance.scheduleItemReminder(widget.item, scheduledTime);
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم ضبط التذكير بنجاح: ${scheduledTime.toString().substring(0, 16)}')));
  }

  @override
  Widget build(BuildContext context) {
    final isUrl = widget.item.type == 'url';
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الملاحظة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.alarm_add),
            tooltip: 'تذكير',
            onPressed: _setReminder,
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isUrl) ...[
              GestureDetector(
                onTap: () => launchUrl(Uri.parse(widget.item.content)),
                child: AbsorbPointer(
                  child: AnyLinkPreview(
                    link: widget.item.content,
                    displayDirection: UIDirection.uiDirectionHorizontal,
                    cache: const Duration(days: 7),
                    backgroundColor: Theme.of(context).cardColor,
                    errorWidget: Container(
                      color: Colors.grey[200],
                      padding: EdgeInsets.all(16.w),
                      child: const Text('لا يمكن معاينة الرابط'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],
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
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'المحتوى',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'الوسوم (مفصولة بفاصلة)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text('حفظ التعديلات', style: TextStyle(fontSize: 16.sp)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
