import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:miloo_mobile/components/default_button.dart';
import 'package:miloo_mobile/services/product_service.dart';
import 'package:miloo_mobile/services/category_service.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  List<XFile>? _images = [];
  String? _selectedCategory;
  String? _selectedSubCategory;
  int _selectedCategoryId = -1;
  int _selectedSubCategoryId = -1;

  List<SelectedListItem> _categories = [];
  List<SelectedListItem> _subCategories = [];
  bool _isLoading = false;

  int _titleCharCount = 0;
  int _descriptionCharCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  final CategoryService _categoryService = CategoryService();

  Future<void> _fetchCategories() async {
    try {
      final categories = await _categoryService.getCategories();
      setState(() {
        _categories = categories
            .map((category) => SelectedListItem(
                  data: {
                    'id': category.id.toString(),
                    'name': category.name,
                  },
                ))
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kategori yüklenirken hata oluştu: $e')),
      );
    }
  }

  Future<void> _fetchSubCategories(int categoryId) async {
    try {
      final subCategories =
          await _categoryService.getSubCategories(categoryId: categoryId);
      setState(() {
        _subCategories = subCategories
            .map((subCategory) => SelectedListItem(
                  data: {
                    'id': subCategory.id.toString(),
                    'name': subCategory.name,
                  },
                ))
            .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Alt kategori yüklenirken hata oluştu: $e')),
      );
    }
  }

  Future<void> _pickImages() async {
    final List<XFile> selectedImages = await _picker.pickMultiImage();
    if (selectedImages.length >= 2 && selectedImages.length <= 4) {
      setState(() {
        _images = selectedImages;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen 2 ile 4 arasında resim seçin.')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _images!.length >= 2) {
      setState(() {
        _isLoading = true;
      });

      try {
        ProductService _productService = ProductService();
        await _productService.addProduct(
          title: _titleController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          subcategoryId: _selectedSubCategoryId,
          images: _images!.map((image) => image.path).toList(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ürün başarıyla eklendi!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ürün eklenirken hata oluştu: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Tüm alanları doldurun ve en az 2 resim seçin.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField(
              controller: _titleController,
              label: 'Başlık',
              icon: Icons.title,
              maxLength: 200,
              charCount: _titleCharCount,
              onChanged: (value) {
                setState(() {
                  _titleCharCount = value.length;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Başlık girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Kategori',
              value: _selectedCategory,
              items: _categories,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                  _selectedCategoryId = int.parse(_categories
                      .firstWhere((item) => item.data['name'] == value)
                      .data['id']);
                  _selectedSubCategory = null;
                  _subCategories = [];
                });
                _fetchSubCategories(_selectedCategoryId);
              },
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Alt Kategori',
              value: _selectedSubCategory,
              items: _subCategories,
              onChanged: (value) {
                setState(() {
                  _selectedSubCategory = value;
                  _selectedSubCategoryId = int.parse(_subCategories
                      .firstWhere((item) => item.data['name'] == value)
                      .data['id']);
                });
              },
            ),
            const SizedBox(height: 16),
            _buildInputField(
              controller: _descriptionController,
              label: 'Açıklama',
              icon: Icons.description,
              maxLines: 3,
              maxLength: 500,
              charCount: _descriptionCharCount,
              onChanged: (value) {
                setState(() {
                  _descriptionCharCount = value.length;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Açıklama girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildInputField(
              controller: _priceController,
              label: 'Fiyat',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Fiyat girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImages,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: _images!.isEmpty
                    ? const Center(child: Text('Resim seçmek için dokunun'))
                    : GridView.builder(
                        itemCount: _images!.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          return Image.file(
                            File(_images![index].path),
                            fit: BoxFit.cover,
                          );
                        },
                      ),
              ),
            ),
            const SizedBox(height: 16),
            DefaultButton(
              text: "Gönder",
              press: _submitForm,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
    int? charCount,
    required String? Function(String?) validator,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[600]!),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<SelectedListItem> items,
    required ValueChanged<String?> onChanged,
  }) {
    return GestureDetector(
      onTap: () {
        DropDownState(
          dropDown: DropDown(
            bottomSheetTitle: Text(label),
            data: items,
            listItemBuilder: (index, dataItem) {
              return ListTile(
                title: Text(dataItem.data['name']),
              );
            },
            onSelected: (selectedList) {
              if (selectedList.isNotEmpty) {
                onChanged(selectedList.first.data['name']);
              }
            },
          ),
        ).showModal(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value ?? 'Seçiniz', style: const TextStyle(fontSize: 16)),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
