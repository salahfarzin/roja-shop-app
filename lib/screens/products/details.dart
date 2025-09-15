import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rojashop/components/async_skeleton_image.dart';
import '../../../models/product.dart';
import '../../providers/product_provider.dart';
import 'package:rojashop/components/details_modal.dart';
import 'package:rojashop/components/success_dialog.dart';
import 'package:easy_localization/easy_localization.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF181922),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
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
                        style: const TextStyle(
                          color: Color(0xFFB0B0B0),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Color(0xFF2EC4F1),
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ],
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
                                  ? Color(0xFF22C55E)
                                  : Color(0xFFE94B4B),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              product.inventory > 0
                                  ? 'in stock'.tr()
                                  : 'out of stock'.tr(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 18),
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFFC107),
                            size: 22,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '4.4',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '(126 Reviews)',
                            style: TextStyle(
                              color: Color(0xFFB0B0B0),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'Product info',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description ??
                            "A cool gray cap in soft corduroy. Watch me. By buying cotton products from Lindex, you’re supporting more responsibly...",
                        style: const TextStyle(
                          color: Color(0xFFB0B0B0),
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Color(0xFF23232B), width: 1),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.info_outline,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'Product Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                          ),
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
                                builder: (context, scrollController) => DetailsModal(
                                  story: product.description ?? '',
                                  details: const [
                                    'Materials: 100% cotton, and lining Structured',
                                    'Adjustable cotton strap closure',
                                    'High-quality embroidery stitching',
                                    'Head circumference: 21” - 24” / 54-62 cm',
                                    'Embroidery stitching',
                                    'One size fits most',
                                  ],
                                  styleNotes: const {
                                    'Style': 'Summer Hat',
                                    'Design': 'Plain',
                                    'Fabric': 'Jersey',
                                  },
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
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.bookmark_border,
                          color: Colors.white,
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
                      backgroundColor: const Color(0xFF6C63FF),
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
                      style: const TextStyle(
                        color: Colors.white,
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
