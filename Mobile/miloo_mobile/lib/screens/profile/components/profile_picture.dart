import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miloo_mobile/size_config.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePicture extends StatefulWidget {
  final String? imageUrl;
  final Function(String) onImageSelected;
  final bool isEdit;

  const ProfilePicture({
    super.key,
    this.imageUrl,
    required this.onImageSelected,
    required this.isEdit,
  });

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  bool _isLoading = false; // Resim yükleme durumunu kontrol etmek için flag

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _isLoading = true; // Yükleme başlıyor
    });

    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
      widget.onImageSelected(pickedFile.path);
    }

    setState(() {
      _isLoading = false; // Yükleme tamamlandı
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(115),
      width: getProportionateScreenWidth(115),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _isLoading
              ? _buildShimmerEffect() // Yükleme sırasında shimmer göster
              : CircleAvatar(
                  backgroundImage: _image != null
                      ? FileImage(File(_image!.path))
                      : (widget.imageUrl != null
                              ? NetworkImage(widget.imageUrl!)
                              : AssetImage('assets/images/default_profile.png'))
                          as ImageProvider,
                ),
          if (widget.isEdit)
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () => _pickImage(ImageSource.gallery),
                child: Container(
                  height: getProportionateScreenHeight(35),
                  width: getProportionateScreenWidth(35),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Shimmer efekti için widget
  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
