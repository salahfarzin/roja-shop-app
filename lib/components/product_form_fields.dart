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
    return Column(
      children: [
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'product name'.tr(),
            labelStyle: TextStyle(color: labelColor),
          ),
          style: TextStyle(color: textColor),
          validator: (v) => v == null || v.isEmpty ? requiredError : null,
        ),
        TextFormField(
          controller: brandController,
          decoration: InputDecoration(
            labelText: 'brand'.tr(),
            labelStyle: TextStyle(color: labelColor),
          ),
          style: TextStyle(color: textColor),
          validator: (v) => v == null || v.isEmpty ? requiredError : null,
        ),
        TextFormField(
          controller: descriptionController,
          decoration: InputDecoration(
            labelText: 'description'.tr(),
            labelStyle: TextStyle(color: labelColor),
          ),
          style: TextStyle(color: textColor),
          maxLines: 3,
          validator: (v) => v == null || v.isEmpty ? requiredError : null,
        ),
        TextFormField(
          controller: oldPriceController,
          decoration: InputDecoration(
            labelText: 'old price'.tr(),
            labelStyle: TextStyle(color: labelColor),
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
        TextFormField(
          controller: discountController,
          decoration: InputDecoration(
            labelText: 'discount (%)'.tr(),
            labelStyle: TextStyle(color: labelColor),
          ),
          style: TextStyle(color: textColor),
          keyboardType: TextInputType.number,
        ),
        TextFormField(
          controller: priceController,
          decoration: InputDecoration(
            labelText: 'price'.tr(),
            labelStyle: TextStyle(color: labelColor),
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
        TextFormField(
          controller: inventoryController,
          decoration: InputDecoration(
            labelText: 'inventory'.tr(),
            labelStyle: TextStyle(color: labelColor),
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
