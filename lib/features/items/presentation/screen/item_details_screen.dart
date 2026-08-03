import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nota/features/items/domain/entity/item_entity.dart';
import 'package:nota/features/items/presentation/controller/items_cubit.dart';
import 'package:any_link_preview/any_link_preview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nota/core/services/notification_service.dart';
import 'package:nota/core/utils/extensions/l10n_extension.dart';

class ItemDetailsScreen extends StatefulWidget {
  final ItemEntity item;

  const ItemDetailsScreen({super.key, required this.item});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late TextEditingController _contentController;
  late TextEditingController _tagsController;
  late String _selectedCategory;
  late final List<String> _categories;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.item.content);
    _tagsController = TextEditingController(text: (widget.item.tags != null && widget.item.tags!.isNotEmpty) ? widget.item.tags : '');
    _selectedCategory = widget.item.category;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _categories = [context.l10n.catOther, context.l10n.catProgramming, context.l10n.catProjects, context.l10n.catStudy, context.l10n.catIdeas];
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
    final updatedItem = ItemEntity(
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
      SnackBar(content: Text(context.l10n.changesSavedSuccessfully)),
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.pleaseChooseFutureTime)));
      return;
    }

    await NotificationService.instance.scheduleItemReminder(widget.item, scheduledTime);
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${context.l10n.reminderSetSuccessfully}: ${scheduledTime.toString().substring(0, 16)}')));
  }

  @override
  Widget build(BuildContext context) {
    final isUrl = widget.item.type == 'url';
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.noteDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.alarm_add),
            tooltip: context.l10n.reminder,
            onPressed: _setReminder,
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
                      padding: const EdgeInsets.all(16),
                      child: Text(context.l10n.cannotPreviewLink),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(labelText: context.l10n.category),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedCategory = val);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: null,
              decoration: InputDecoration(
                labelText: context.l10n.content,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(
                labelText: context.l10n.tagsCommaSeparated,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(context.l10n.saveChanges, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
