import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProductDetailsFields extends StatelessWidget {
  final TextEditingController skuController;
  final TextEditingController barcodeController;
  final TextEditingController weightController;
  final Color labelColor;
  final Color textColor;

  const ProductDetailsFields({
    super.key,
    required this.skuController,
    required this.barcodeController,
    required this.weightController,
    required this.labelColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: skuController,
          decoration: InputDecoration(
            labelText: 'sku'.tr(),
            labelStyle: TextStyle(color: labelColor),
          ),
          style: TextStyle(color: textColor),
        ),
        TextFormField(
          controller: barcodeController,
          decoration: InputDecoration(
            labelText: 'barcode'.tr(),
            labelStyle: TextStyle(color: labelColor),
          ),
          style: TextStyle(color: textColor),
        ),
        TextFormField(
          controller: weightController,
          decoration: InputDecoration(
            labelText: 'weight (kg)'.tr(),
            labelStyle: TextStyle(color: labelColor),
          ),
          style: TextStyle(color: textColor),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    );
  }
}
