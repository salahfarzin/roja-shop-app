import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductFormFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController brandController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController oldPriceController;
  final TextEditingController discountController;
  final TextEditingController inventoryController;
  final Color labelColor;
  final Color textColor;
  final String requiredError;

  const ProductFormFields({
    super.key,
    required this.titleController,
    required this.brandController,
    required this.descriptionController,
    required this.priceController,
    required this.oldPriceController,
    required this.discountController,
    required this.inventoryController,
    required this.labelColor,
    required this.textColor,
    required this.requiredError,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: theme.dividerColor.withValues(alpha: 0.18),
        width: 1.2,
      ),
    );
    final contentPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 14);
    final fillColor =
        theme.inputDecorationTheme.fillColor ??
        theme.cardColor.withValues(
          alpha: theme.brightness == Brightness.dark ? 0.12 : 0.04,
        );
    final labelStyle =
        theme.inputDecorationTheme.labelStyle ??
        TextStyle(
          color: theme.hintColor,
          fontWeight: FontWeight.w500,
          fontSize: 15,
        );
    return Column(
      children: [
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'product name'.tr(),
            labelStyle: labelStyle,
            filled: true,
            fillColor: fillColor,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            contentPadding: contentPadding,
          ),
          style: TextStyle(color: textColor),
          validator: (v) => v == null || v.isEmpty ? requiredError : null,
        ),
        SizedBox(height: 12),
        TextFormField(
          controller: brandController,
          decoration: InputDecoration(
            labelText: 'brand'.tr(),
            labelStyle: labelStyle,
            filled: true,
            fillColor: fillColor,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            contentPadding: contentPadding,
          ),
          style: TextStyle(color: textColor),
          validator: (v) => v == null || v.isEmpty ? requiredError : null,
        ),
        SizedBox(height: 12),
        TextFormField(
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: 'description'.tr(),
            labelStyle: labelStyle,
            filled: true,
            fillColor: fillColor,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            contentPadding: contentPadding,
          ),
          style: TextStyle(color: textColor),
          maxLines: 3,
          validator: (v) => v == null || v.isEmpty ? requiredError : null,
        ),
        SizedBox(height: 12),
        TextFormField(
          controller: oldPriceController,
          decoration: InputDecoration(
            labelText: 'old price'.tr(),
            labelStyle: labelStyle,
            filled: true,
            fillColor: fillColor,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            contentPadding: contentPadding,
          ),
          style: TextStyle(color: textColor),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*')),
          ],
          validator: (v) {
            if (v == null || v.isEmpty) return null;
            final d = double.tryParse(v);
            if (d == null) return 'must be a number'.tr();
            if (d < 0) return 'must be positive'.tr();
            return null;
          },
        ),
        SizedBox(height: 12),
        TextFormField(
          controller: discountController,
          decoration: InputDecoration(
            labelText: 'discount (%)'.tr(),
            labelStyle: labelStyle,
            filled: true,
            fillColor: fillColor,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            contentPadding: contentPadding,
          ),
          style: TextStyle(color: textColor),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 12),
        TextFormField(
          controller: priceController,
          decoration: InputDecoration(
            labelText: 'price'.tr(),
            labelStyle: labelStyle,
            filled: true,
            fillColor: fillColor,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            contentPadding: contentPadding,
          ),
          style: TextStyle(color: textColor),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*')),
          ],
          validator: (v) {
            if (v == null || v.isEmpty) return requiredError;
            final d = double.tryParse(v);
            if (d == null) return 'must be a number'.tr();
            if (d < 0) return 'must be positive'.tr();
            return null;
          },
        ),
        SizedBox(height: 12),
        TextFormField(
          controller: inventoryController,
          decoration: InputDecoration(
            labelText: 'inventory'.tr(),
            labelStyle: labelStyle,
            filled: true,
            fillColor: fillColor,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            contentPadding: contentPadding,
          ),
          style: TextStyle(color: textColor),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (v) {
            if (v == null || v.isEmpty) return requiredError;
            final n = int.tryParse(v);
            if (n == null) return 'must be an integer'.tr();
            if (n < 0) return 'must be positive'.tr();
            return null;
          },
        ),
      ],
    );
  }
}
