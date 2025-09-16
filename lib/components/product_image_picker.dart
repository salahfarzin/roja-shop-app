import 'package:flutter/material.dart';

class ProductImagePicker extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onPickImage;
  final bool isUploading;
  final double uploadProgress;

  const ProductImagePicker({
    super.key,
    required this.imageUrl,
    required this.onPickImage,
    required this.isUploading,
    required this.uploadProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: isUploading ? null : onPickImage,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(imageUrl!, fit: BoxFit.cover),
                  )
                : Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
          ),
        ),
        if (isUploading)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: LinearProgressIndicator(value: uploadProgress),
          ),
      ],
    );
  }
}
