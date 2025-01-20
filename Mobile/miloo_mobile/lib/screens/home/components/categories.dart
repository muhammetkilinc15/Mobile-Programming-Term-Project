import 'package:flutter/material.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:provider/provider.dart';
import 'package:miloo_mobile/models/category_model.dart';
import 'package:miloo_mobile/screens/home/components/category_card.dart';
import 'package:miloo_mobile/screens/store/store_screen.dart';
import 'package:miloo_mobile/providers/category_provider.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().getHomeCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, _) {
        if (categoryProvider.isLoading &&
            categoryProvider.homecategories.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: kPrimaryColor,
            ),
          );
        } else if (categoryProvider.error.isNotEmpty) {
          return Center(child: Text('Error: ${categoryProvider.error}'));
        } else if (categoryProvider.homecategories.isEmpty) {
          return const Center(child: Text('No categories found'));
        } else {
          List<CategoryModel> categories = categoryProvider.homecategories;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return StoreScreen(
                            initialCategoryId: category.id,
                          );
                        },
                      ),
                    );
                  },
                  child: CategoryCard(
                    icon: Icons.gamepad,
                    text: category.name,
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
