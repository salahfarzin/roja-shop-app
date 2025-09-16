// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart' as trans;
import 'package:flutter/material.dart';
import 'package:rojashop/components/image_picker_field.dart';
import 'package:rojashop/components/product_form_fields.dart';
import 'package:rojashop/components/primary_action_button.dart';
import 'package:provider/provider.dart';
import 'package:rojashop/components/success_dialog.dart';
import 'package:rojashop/models/product.dart';
import 'package:rojashop/providers/product_provider.dart';
import 'package:rojashop/components/key_value_list_field.dart';
// Removed stray function declaration

class AddProductScreen extends StatefulWidget {
  final Product? product;
  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  bool _isLoading = false;
  double _uploadProgress = 0.0;

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
  void initState() {
    super.initState();
    final product = widget.product;
    if (product != null) {
      _titleController.text = product.title;
      _brandController.text = product.brand;
      _descriptionController.text = product.description ?? '';
      _priceController.text = product.price.toString();
      _oldPriceController.text = product.oldPrice?.toString() ?? '';
      _discountController.text = product.discount?.toString() ?? '';
      _inventoryController.text = product.inventory.toString();
      _imagePath = product.image;
      _details = Map<String, String>.from(
        product.details?.map((k, v) => MapEntry(k, v.toString())) ?? {},
      );
      _styleNotes = Map<String, String>.from(
        product.styleNotes?.map((k, v) => MapEntry(k, v.toString())) ?? {},
      );
    }
  }

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
    final String requiredError = 'required'.tr();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.product == null ? 'add product'.tr() : 'edit product'.tr(),
          ),
        ),
        body: Consumer<ProductProvider>(
          builder: (context, provider, child) {
            // Get latest product from provider if editing
            Product? editingProduct;
            if (widget.product != null) {
              editingProduct = provider.products.firstWhere(
                (p) => p.id == widget.product!.id,
                orElse: () => widget.product!,
              );
              // Update inventory textbox if editing
              final inv = editingProduct.inventory;
              if (inv == 0 && _inventoryController.text != '') {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _inventoryController.text = '';
                });
              } else if (inv != 0 &&
                  _inventoryController.text != inv.toString()) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _inventoryController.text = inv.toString();
                });
              }
            }

            return Padding(
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
                    ProductFormFields(
                      titleController: _titleController,
                      brandController: _brandController,
                      descriptionController: _descriptionController,
                      priceController: _priceController,
                      oldPriceController: _oldPriceController,
                      discountController: _discountController,
                      inventoryController: _inventoryController,
                      labelColor: labelColor,
                      textColor: textColor,
                      requiredError: requiredError,
                    ),
                    if (editingProduct != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '${'current inventory'.tr()}: ${editingProduct.inventory}',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
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
                    const SizedBox(height: 24),
                    PrimaryActionButton(
                      text: widget.product == null
                          ? 'save'.tr()
                          : 'update'.tr(),
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                if (_imagePath == null || _imagePath!.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'image is required'.tr(),
                                        textDirection: TextDirection.rtl,
                                      ),
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    ),
                                  );
                                  return;
                                }
                                setState(() {
                                  _isLoading = true;
                                  _uploadProgress = 0.0;
                                });
                                final productData = {
                                  'title': _titleController.text,
                                  'brand': _brandController.text,
                                  'inventory': int.tryParse(
                                    _inventoryController.text,
                                  ),
                                  'price': double.tryParse(
                                    _priceController.text,
                                  ),
                                  'old_price': double.tryParse(
                                    _oldPriceController.text,
                                  ),
                                  'discount': double.tryParse(
                                    _discountController.text,
                                  ),
                                  'description': _descriptionController.text,
                                  'details': _details,
                                  'style_notes': _styleNotes,
                                  'image': _imagePath ?? '',
                                };

                                dynamic result;
                                if (widget.product != null) {
                                  // Update product logic
                                  result = await provider.updateProduct(
                                    widget.product!.id,
                                    productData,
                                    onProgress: (progress) {
                                      setState(() {
                                        _uploadProgress = progress;
                                      });
                                    },
                                  );

                                  Navigator.pushNamed(
                                    context,
                                    '/product-details',
                                    arguments: result,
                                  );
                                } else {
                                  // Add product logic
                                  result = await provider.addProduct(
                                    productData,
                                    onProgress: (progress) {
                                      setState(() {
                                        _uploadProgress = progress;
                                      });
                                    },
                                  );
                                }
                                setState(() {
                                  _isLoading = false;
                                  _uploadProgress = 0.0;
                                });
                                if (result is Product) {
                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) =>
                                          SuccessDialog(text: 'success'.tr()),
                                    );
                                    if (widget.product == null) {
                                      // Clear the form for next entry only if adding
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
                                    }
                                  }
                                } else {
                                  if (context.mounted) {
                                    final error =
                                        provider.errorMessage ??
                                        'Failed to save product.';
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          error,
                                          textDirection: TextDirection.ltr,
                                        ),
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                      backgroundColor: theme.colorScheme.secondary,
                      textColor: theme.colorScheme.onSecondary,
                    ),
                    if (_isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: LinearProgressIndicator(value: _uploadProgress),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
