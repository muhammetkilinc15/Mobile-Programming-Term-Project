import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:miloo_mobile/components/default_button.dart';
import 'package:miloo_mobile/constraits/validators.dart';
import 'package:miloo_mobile/providers/category_provider.dart';
import 'package:miloo_mobile/screens/product/add_product/components/custom_drop_down.dart';
import 'package:miloo_mobile/screens/product/add_product/components/custom_input_field.dart';
import 'package:miloo_mobile/screens/product/add_product/components/image_picker.dart';
import 'package:miloo_mobile/screens/user/my_shared_products/my_shared_products_screen.dart';
import 'package:miloo_mobile/services/product_service.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  List<String> selectedImages = []; // List of selected images
  String? _selectedCategory; // Selected category
  String? _selectedSubCategory; // Selected subcategory
  int _selectedSubCategoryId = -1;
  int _selectedCategoryId = -1;
  int _titleCharCount = 0;
  int _descriptionCharCount = 0;

  @override
  void initState() {
    super.initState();
    // Wait for widget tree to be built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Safely fetch categories after widget is mounted
      context
          .read<CategoryProvider>()
          .getCategories(pageNumber: 1, pageSize: 20 // Load first 20 categories
              );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomInputField(
              controller: _titleController,
              label: 'Title',
              icon: Icons.title,
              validator: titleValidator.call,
              charCount: _titleCharCount,
              maxLength: 50,
              maxLines: 1,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                setState(() {
                  _titleCharCount = value.length;
                });
              },
            ),
            const SizedBox(height: 16),
            CustomInputField(
              controller: _descriptionController,
              label: 'Description',
              icon: Icons.description,
              maxLines: 3,
              charCount: _descriptionCharCount,
              maxLength: 300,
              keyboardType: TextInputType.multiline,
              onChanged: (value) {
                setState(() {
                  _descriptionCharCount = value.length;
                });
              },
              validator: descriptionValidator.call,
            ),
            const SizedBox(height: 16),
            Consumer<CategoryProvider>(builder: (context, provider, _) {
              return Column(
                children: [
                  CustomDropdownField(
                    label: 'Category',
                    value: _selectedCategory,
                    items: provider.categories
                        .map((category) => SelectedListItem(data: {
                              'id': category.id.toString(),
                              'name': category.name,
                            }))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                          _selectedCategoryId = int.parse(provider.categories
                              .firstWhere((c) => c.name == value)
                              .id
                              .toString());
                          _selectedSubCategory = null;
                          _selectedSubCategoryId = -1;
                        });
                        provider.getSubCategories(_selectedCategoryId);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_selectedCategoryId != -1)
                    CustomDropdownField(
                      label: 'Subcategory',
                      value: _selectedSubCategory,
                      items: provider.subcategories
                          .map((subcategory) => SelectedListItem(data: {
                                'id': subcategory.id.toString(),
                                'name': subcategory.name,
                              }))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedSubCategory = value;
                            _selectedSubCategoryId = int.parse(provider
                                .subcategories
                                .firstWhere((s) => s.name == value)
                                .id
                                .toString());
                          });
                        }
                      },
                    ),
                ],
              );
            }),
            const SizedBox(height: 16),
            CustomInputField(
              controller: _priceController,
              label: 'Price',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
              validator: priceValidator.call,
            ),
            const SizedBox(height: 16),
            ImagePickerWidget(
              selectedImages: selectedImages,
              onImagesSelected: (images) {
                setState(() => selectedImages = images);
              },
            ),
            const SizedBox(height: 24),
            DefaultButton(
              text: "Add Product",
              press: () {
                _handleSubmit();
                Navigator.pushReplacementNamed(
                    context, MySharedProductsScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedImages.length < 2 || selectedImages.length > 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select between 2 and 4 product images'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    try {
      final ProductService productService = ProductService();
      await productService.addProduct(
          title: _titleController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          subcategoryId: _selectedSubCategoryId,
          images: selectedImages);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error adding product. Please try again later'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
