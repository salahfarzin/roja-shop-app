import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImagePickerField extends StatefulWidget {
  final String? initialImagePath;
  final void Function(String? path) onImagePicked;
  const ImagePickerField({
    super.key,
    this.initialImagePath,
    required this.onImagePicked,
  });

  @override
  State<ImagePickerField> createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _imagePath = widget.initialImagePath;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imagePath = picked.path;
      });
      widget.onImagePicked(_imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 120,
        color: Colors.grey[200],
        child: _imagePath == null
            ? const Icon(Icons.add_a_photo, size: 48)
            : (_imagePath!.startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: _imagePath!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image, size: 48),
                    )
                  : Image.file(File(_imagePath!), fit: BoxFit.cover)),
      ),
    );
  }
}
