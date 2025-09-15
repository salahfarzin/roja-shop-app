import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rojashop/components/image_picker_field.dart';
import 'package:provider/provider.dart';
import 'package:rojashop/providers/product_provider.dart';
import 'package:rojashop/components/key_value_list_field.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _brandController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _oldPriceController = TextEditingController();
  final _discountController = TextEditingController();
  final _inventoryController = TextEditingController();
  String? _imagePath;
  Map<String, String> _details = {};
  Map<String, String> _styleNotes = {};

  @override
  void dispose() {
    _titleController.dispose();
    _brandController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _oldPriceController.dispose();
    _discountController.dispose();
    _inventoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelColor =
        theme.inputDecorationTheme.labelStyle?.color ??
        theme.textTheme.bodyLarge?.color ??
        Colors.black;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text('add product'.tr())),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                ImagePickerField(
                  initialImagePath: _imagePath,
                  onImagePicked: (path) {
                    setState(() {
                      _imagePath = path;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'product name'.tr(),
                    labelStyle: TextStyle(color: labelColor),
                  ),
                  style: TextStyle(color: textColor),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _brandController,
                  decoration: InputDecoration(
                    labelText: 'brand'.tr(),
                    labelStyle: TextStyle(color: labelColor),
                  ),
                  style: TextStyle(color: textColor),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'description'.tr(),
                    labelStyle: TextStyle(color: labelColor),
                  ),
                  style: TextStyle(color: textColor),
                  maxLines: 3,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                KeyValueListField(
                  title: 'details'.tr(),
                  initialValues: _details,
                  onChanged: (map) => setState(() => _details = map),
                ),
                const SizedBox(height: 12),
                KeyValueListField(
                  title: 'style notes'.tr(),
                  initialValues: _styleNotes,
                  onChanged: (map) => setState(() => _styleNotes = map),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _oldPriceController,
                  decoration: InputDecoration(
                    labelText: 'old price'.tr(),
                    labelStyle: TextStyle(color: labelColor),
                  ),
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _discountController,
                  decoration: InputDecoration(
                    labelText: 'discount (%)'.tr(),
                    labelStyle: TextStyle(color: labelColor),
                  ),
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'price'.tr(),
                    labelStyle: TextStyle(color: labelColor),
                  ),
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _inventoryController,
                  decoration: InputDecoration(
                    labelText: 'inventory'.tr(),
                    labelStyle: TextStyle(color: labelColor),
                  ),
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    final n = int.tryParse(v);
                    if (n == null) return 'Must be an integer';
                    if (n < 0) return 'Must be positive';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final productData = {
                        'title': _titleController.text,
                        'brand': _brandController.text,
                        'description': _descriptionController.text,
                        'price': double.tryParse(_priceController.text),
                        'oldPrice': double.tryParse(_oldPriceController.text),
                        'discount': double.tryParse(_discountController.text),
                        'inventory': int.tryParse(_inventoryController.text),
                        'image': _imagePath ?? '',
                        'details': _details,
                        'styleNotes': _styleNotes,
                      };
                      final provider = Provider.of<ProductProvider>(
                        context,
                        listen: false,
                      );
                      final result = await provider.addProduct(productData);
                      if (result != null) {
                        if (context.mounted) Navigator.pop(context);
                        // Only clear the form after successful add and after navigation
                        _titleController.clear();
                        _brandController.clear();
                        _descriptionController.clear();
                        _priceController.clear();
                        _oldPriceController.clear();
                        _discountController.clear();
                        _inventoryController.clear();
                        setState(() {
                          _details = {};
                          _styleNotes = {};
                          _imagePath = null;
                        });
                      } else {
                        if (context.mounted) {
                          final error =
                              provider.errorMessage ?? 'Failed to add product.';
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(error)));
                        }
                      }
                    }
                  },
                  child: Text('save'.tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
