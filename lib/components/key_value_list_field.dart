import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class KeyValueListField extends StatefulWidget {
  final String title;
  final Map<String, String>? initialValues;
  final void Function(Map<String, String>) onChanged;

  const KeyValueListField({
    super.key,
    required this.title,
    this.initialValues,
    required this.onChanged,
  });

  @override
  State<KeyValueListField> createState() => _KeyValueListFieldState();
}

class _KeyValueListFieldState extends State<KeyValueListField> {
  late List<MapEntry<String, String>> entries;

  @override
  void initState() {
    super.initState();
    entries = widget.initialValues?.entries.toList() ?? [];
  }

  void _addEntry() {
    setState(() {
      entries.add(const MapEntry('', ''));
    });
    _notifyChange();
  }

  void _removeEntry(int index) {
    setState(() {
      entries.removeAt(index);
    });
    _notifyChange();
  }

  void _updateKey(int index, String key) {
    setState(() {
      entries[index] = MapEntry(key, entries[index].value);
    });
    _notifyChange();
  }

  void _updateValue(int index, String value) {
    setState(() {
      entries[index] = MapEntry(entries[index].key, value);
    });
    _notifyChange();
  }

  void _notifyChange() {
    final map = <String, String>{};
    for (final entry in entries) {
      if (entry.key.trim().isNotEmpty) {
        map[entry.key.trim()] = entry.value.trim();
      }
    }
    widget.onChanged(map);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.titleMedium),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addEntry,
              tooltip: 'Add',
            ),
          ],
        ),
        ...List.generate(entries.length, (i) {
          return Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(hintText: 'key'.tr()),
                  initialValue: entries[i].key,
                  onChanged: (v) => _updateKey(i, v),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(hintText: 'value'.tr()),
                  initialValue: entries[i].value,
                  onChanged: (v) => _updateValue(i, v),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeEntry(i),
                tooltip: 'remove'.tr(),
              ),
            ],
          );
        }),
      ],
    );
  }
}
