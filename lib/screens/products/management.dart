import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';

class ProductManagementScreen extends StatelessWidget {
  const ProductManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('manage products'.tr())),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          if (provider.status == ProductStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.status == ProductStatus.error) {
            return Center(
              child: Text(provider.errorMessage ?? 'Failed to load products'),
            );
          }
          final products = provider.products;
          if (products.isEmpty) {
            return Center(child: Text('No products found'.tr()));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(product.image),
                  ),
                  title: Text(product.title),
                  subtitle: Text(product.brand),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Edit',
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/edit-product',
                        arguments: product.id,
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/edit-product',
                      arguments: product.id,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
