import 'package:flutter/material.dart';

class ProductFormActions extends StatelessWidget {
  final VoidCallback onSave;
  final bool isSaving;
  final bool isEditMode;

  const ProductFormActions({
    super.key,
    required this.onSave,
    required this.isSaving,
    required this.isEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isSaving ? null : onSave,
        child: isSaving
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(isEditMode ? 'Update' : 'Save'),
      ),
    );
  }
}
