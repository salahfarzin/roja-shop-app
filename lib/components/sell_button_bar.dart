import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:provider/provider.dart';
import 'package:rojashop/models/product.dart';
import '../../providers/product_provider.dart';
import 'package:rojashop/components/success_dialog.dart';
import 'package:easy_localization/easy_localization.dart' as trans;

class SellButtonBar extends StatelessWidget {
  final Color accentColor;
  final bool isRtl;
  final dynamic product;
  final bool isSelling;
  final Function(bool) setSelling;

  const SellButtonBar({
    super.key,
    required this.accentColor,
    required this.isRtl,
    required this.product,
    required this.isSelling,
    required this.setSelling,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            disabledForegroundColor: Theme.of(
              context,
            ).colorScheme.onSecondary.withValues(alpha: 0.5),
            disabledBackgroundColor: accentColor.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: (product.inventory > 0 && !isSelling)
              ? () async {
                  setSelling(true);
                  final provider = Provider.of<ProductProvider>(
                    context,
                    listen: false,
                  );
                  try {
                    final result = await provider.sellProduct(product.id);
                    if (result is Product && context.mounted) {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        barrierColor: Colors.black.withAlpha(
                          (0.5 * 255).toInt(),
                        ),
                        builder: (context) => SuccessDialog(
                          text: "${'sold count'.tr()}: ${result.soldCount}",
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'failed to sell product'.tr(),
                            textDirection: isRtl
                                ? ui.TextDirection.rtl
                                : ui.TextDirection.ltr,
                          ),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }
                  } finally {
                    if (context.mounted) setSelling(false);
                  }
                }
              : null,
          child: isSelling
              ? Center(child: CircularProgressIndicator())
              : Directionality(
                  textDirection: isRtl
                      ? ui.TextDirection.rtl
                      : ui.TextDirection.ltr,
                  child: Text(
                    'sell'.tr(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
