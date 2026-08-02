import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nota/features/items/data/model/item_model.dart';
import 'package:nota/features/items/presentation/controller/items_cubit.dart';
import 'package:nota/core/utils/extensions/l10n_extension.dart';

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
  late String _selectedCategory;
  late final List<String> _categories;

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
    _categories = [context.l10n.catOther, context.l10n.catProgramming, context.l10n.catProjects, context.l10n.catStudy, context.l10n.catIdeas];
    _selectedCategory = context.l10n.catOther;
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
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.addNewNote,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'text', icon: const Icon(Icons.notes), label: Text(context.l10n.text)),
              ButtonSegment(value: 'url', icon: const Icon(Icons.link), label: Text(context.l10n.link)),
            ],
            selected: {_selectedType},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _selectedType = newSelection.first;
              });
            },
          ),
          const SizedBox(height: 16),
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
            maxLines: _selectedType == 'text' ? 4 : 1,
            decoration: InputDecoration(
              hintText: _selectedType == 'text' ? context.l10n.writeYourNoteHere : context.l10n.pasteLinkHere,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _tagsController,
            decoration: InputDecoration(
              hintText: context.l10n.tagsCommaSeparated,
              prefixIcon: const Icon(Icons.tag),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveItem,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              context.l10n.save,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
