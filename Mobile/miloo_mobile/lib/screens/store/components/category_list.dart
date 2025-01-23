import 'package:flutter/material.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/models/category_model.dart';

class CategoryList extends StatelessWidget {
  final List<CategoryModel> categories;
  final int selectedCategoryId;
  final Function(int) onCategorySelected;

  const CategoryList({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryChip(-1, 'All'),
          ...categories.map(
              (category) => _buildCategoryChip(category.id, category.name)),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(int id, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: selectedCategoryId == id ? Colors.white : Colors.black,
          ),
        ),
        selected: selectedCategoryId == id,
        selectedColor: kPrimaryColor,
        onSelected: (_) => onCategorySelected(id),
      ),
    );
  }
}
