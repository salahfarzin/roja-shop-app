import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' as trans;

// Reusable key-value section widget
class _KeyValueSection extends StatelessWidget {
  final String title;
  final Map<String, dynamic> data;
  final Color titleColor;
  final Color subtitleColor;
  final double topSpacing;
  final double titleSpacing;
  const _KeyValueSection({
    required this.title,
    required this.data,
    required this.titleColor,
    required this.subtitleColor,
    this.topSpacing = 16,
    this.titleSpacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: topSpacing),
        Text(
          title.tr(),
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: titleSpacing),
        ...data.entries.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Directionality.of(context) == TextDirection.rtl
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    child: Text(
                      '${e.key}:',
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Text(
                    e.value?.toString() ?? '',
                    style: TextStyle(color: subtitleColor, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DetailsModal extends StatelessWidget {
  final String story;
  final Map<String, dynamic>? details;
  final Map<String, dynamic>? styleNotes;

  const DetailsModal({
    super.key,
    required this.story,
    this.details,
    this.styleNotes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor =
        theme.bottomSheetTheme.backgroundColor ?? theme.cardColor;
    final titleColor = theme.textTheme.titleLarge?.color ?? Colors.white;
    final subtitleColor =
        theme.textTheme.bodyMedium?.color ?? const Color(0xFFB0B0B0);
    final dividerColor = theme.dividerColor;
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Center(
              child: Text(
                'description'.tr(),
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(story, style: TextStyle(color: subtitleColor, fontSize: 15)),
            const SizedBox(height: 18),

            if (details != null)
              _KeyValueSection(
                title: 'details',
                data: details!,
                titleColor: titleColor,
                subtitleColor: subtitleColor,
                topSpacing: 16,
                titleSpacing: 8,
              ),
            const SizedBox(height: 8),
            if (styleNotes != null)
              _KeyValueSection(
                title: 'style notes',
                data: styleNotes!,
                titleColor: titleColor,
                subtitleColor: subtitleColor,
                topSpacing: 18,
                titleSpacing: 18,
              ),
          ],
        ),
      ),
    );
  }
}
