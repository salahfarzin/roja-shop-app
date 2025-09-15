import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rojashop/components/async_skeleton_image.dart';
import '../../../models/product.dart';
import '../../providers/product_provider.dart';
import 'package:rojashop/components/details_modal.dart';
import 'package:rojashop/components/success_dialog.dart';
import 'package:easy_localization/easy_localization.dart' as trans;

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final secondaryTextColor =
        theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7) ??
        const Color(0xFFB0B0B0);
    final cardColor = theme.cardColor;
    final iconColor = theme.iconTheme.color ?? Colors.white;
    final accentColor = theme.colorScheme.secondary;
    final borderColor = theme.dividerColor;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 60),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: product.image.startsWith('http')
                        ? AsyncSkeletonImage(
                            url: product.image,
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            product.image,
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        product.brand,
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.title,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontFamily: 'RobotoMono',
                                color: accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: product.inventory > 0
                                  ? const Color(0xFF22C55E)
                                  : const Color(0xFFE94B4B),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              product.inventory > 0
                                  ? 'in stock'.tr()
                                  : 'out of stock'.tr(),
                              style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          // Icon(Icons.star, color: Colors.amber, size: 22),
                          // const SizedBox(width: 4),
                          // Text(
                          //   '4.4',
                          //   style: TextStyle(
                          //     color: textColor,
                          //     fontWeight: FontWeight.bold,
                          //     fontSize: 16,
                          //   ),
                          // ),
                          // const SizedBox(width: 4),
                          // Text(
                          //   '(126 Reviews)',
                          //   style: TextStyle(
                          //     color: secondaryTextColor,
                          //     fontSize: 14,
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'info'.tr(),
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description ?? "",
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: borderColor, width: 1),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.info_outline, color: iconColor),
                          title: Text(
                            'details'.tr(),
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          trailing: Icon(Icons.chevron_right, color: iconColor),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => DraggableScrollableSheet(
                                initialChildSize: 0.7,
                                minChildSize: 0.5,
                                maxChildSize: 0.95,
                                expand: false,
                                builder: (context, scrollController) =>
                                    DetailsModal(
                                      story: product.description ?? '',
                                      details: product.details,
                                      styleNotes: product.styleNotes,
                                    ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ],
            ),
            // Top bar icons
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: iconColor, size: 28),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: cardColor.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.bookmark_border,
                          color: iconColor,
                          size: 24,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom price bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: product.inventory > 0
                        ? () async {
                            final provider = Provider.of<ProductProvider>(
                              context,
                              listen: false,
                            );
                            final count = await provider.sellProduct(
                              product.id,
                            );
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierColor: Colors.black.withAlpha(
                                  (0.5 * 255).toInt(),
                                ),
                                builder: (context) => SuccessDialog(
                                  text: "${'sold count'.tr()}: $count",
                                ),
                              );
                            }
                          }
                        : null,
                    child: Text(
                      'sell'.tr(),
                      style: TextStyle(
                        color: theme.colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
