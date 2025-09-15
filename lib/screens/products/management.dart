import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProductManagementScreen extends StatelessWidget {
  const ProductManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('manage products'.tr())),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: Text('add product'.tr()),
          onPressed: () {
            Navigator.pushNamed(context, '/add-product');
          },
        ),
      ),
    );
  }
}
