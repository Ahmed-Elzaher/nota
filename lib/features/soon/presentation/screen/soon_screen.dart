import 'package:flutter/material.dart';
import 'package:nota/core/utils/extensions/l10n_extension.dart';
import 'package:hugeicons/hugeicons.dart';

class SoonScreen extends StatelessWidget {
  const SoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(
            icon: HugeIcons.strokeRoundedClock01,
            color: Theme.of(context).primaryColor,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.soon,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.underConstruction,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
