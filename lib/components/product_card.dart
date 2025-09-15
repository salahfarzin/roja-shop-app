import 'package:easy_localization/easy_localization.dart' as trans;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../models/product.dart';
import '../screens/products/details.dart';
import 'package:rojashop/components/async_skeleton_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isRtl = Provider.of<LocaleProvider>(context).isRtl;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Card(
        color: theme.cardColor,
        child: Container(
          constraints: const BoxConstraints(minHeight: 260),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AsyncSkeletonImage(url: product.image),
                    ),
                    if (product.discount != null)
                      Positioned(
                        top: 8,
                        left: isRtl ? 8 : null,
                        right: isRtl ? null : 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE94B4B),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${product.discount?.round()}%',
                            style: const TextStyle(
                              fontFamily: 'RobotoMono',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  product.brand,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    color: Color(0xFFB0B0B0),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: product.inventory > 0
                        ? Color(0xFF22C55E)
                        : Color(0xFFE94B4B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    product.inventory > 0
                        ? trans.tr('in stock')
                        : trans.tr('out of stock'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontFamily: 'RobotoMono',
                          color: Color(0xFF2EC4F1),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (product.oldPrice != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '\$${product.oldPrice!.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontFamily: 'RobotoMono',
                            color: Color(0xFFB0B0B0),
                            fontSize: 13,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
