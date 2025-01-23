import 'package:flutter/material.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/models/sub_category_model.dart';

class SubcategoryList extends StatelessWidget {
  final List<SubCategoryModel> subcategories;
  final int selectedSubcategoryId;
  final Function(int) onSubcategorySelected;

  const SubcategoryList({
    Key? key,
    required this.subcategories,
    required this.selectedSubcategoryId,
    required this.onSubcategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: subcategories.map((subcategory) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(
                subcategory.name,
                style: TextStyle(
                  color: selectedSubcategoryId == subcategory.id
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              selected: selectedSubcategoryId == subcategory.id,
              selectedColor: kPrimaryColor,
              backgroundColor: Colors.grey[200],
              onSelected: (_) => onSubcategorySelected(subcategory.id),
            ),
          );
        }).toList(),
      ),
    );
  }
}
