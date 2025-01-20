import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/models/product_model.dart';
import 'package:miloo_mobile/providers/category_provider.dart';
import 'package:miloo_mobile/providers/product_provider.dart';
import 'package:miloo_mobile/screens/home/components/product_card.dart';
import 'package:miloo_mobile/screens/product_detail/product_detail_screen.dart';
import 'package:miloo_mobile/size_config.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatefulWidget {
  final int? initialCategoryId;
  const StoreScreen({
    super.key,
    this.initialCategoryId,
  });

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    try {
      final categoryProvider = context.read<CategoryProvider>();
      final productProvider = context.read<ProductProvider>();

      await categoryProvider.getCategories();

      if (widget.initialCategoryId != null) {
        categoryProvider.setSelectedCategory(widget.initialCategoryId!);
        await productProvider.getProducts(
          categoryId: widget.initialCategoryId!,
          orderBy: productProvider.sortBy,
        );
      } else {
        await productProvider.getProducts(
          orderBy: productProvider.sortBy,
        );
      }
    } catch (e) {
      print('Error loading initial data: $e');
    }
  }

  Future<void> _onCategorySelected(int categoryId) async {
    final categoryProvider = context.read<CategoryProvider>();
    final productProvider = context.read<ProductProvider>();

    categoryProvider.setSelectedCategory(categoryId);
    await productProvider.getProducts(
      categoryId: categoryId,
      orderBy: productProvider.sortBy,
    );
  }

  Future<void> _onSubCategorySelected(int subcategoryId) async {
    final categoryProvider = context.read<CategoryProvider>();
    final productProvider = context.read<ProductProvider>();

    categoryProvider.setSelectedSubcategory(subcategoryId);
    await productProvider.getProducts(
      categoryId: categoryProvider.selectedCategoryId,
      subcategoryId: subcategoryId,
      orderBy: productProvider.sortBy,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        leading: Padding(
          padding: EdgeInsets.only(left: getProportionateScreenWidth(10)),
          child: widget.initialCategoryId != null
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () => Navigator.pop(context),
                )
              : SvgPicture.asset(
                  'assets/logo/Shoplon.svg',
                  width: getProportionateScreenWidth(50),
                  height: getProportionateScreenHeight(50),
                ),
        ),
        actions: [
          Consumer<ProductProvider>(
            builder: (context, provider, _) => DropdownButton<String>(
              value: provider.sortBy,
              underline: const SizedBox(),
              icon: const Icon(Icons.sort, color: Colors.white),
              items: const [
                DropdownMenuItem(value: 'popular', child: Text('Popular')),
                DropdownMenuItem(value: 'price', child: Text('Price')),
                DropdownMenuItem(value: 'newest', child: Text('Newest')),
              ],
              onChanged: (value) async {
                if (value != null) {
                  final categoryProvider = context.read<CategoryProvider>();
                  await provider.getProducts(
                    categoryId: categoryProvider.selectedCategoryId,
                    subcategoryId: categoryProvider.selectedSubcategoryId,
                    orderBy: value,
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Main Categories
          Consumer<CategoryProvider>(
            builder: (context, categoryProvider, _) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ChoiceChip(
                      label: const Text('All'),
                      selected: categoryProvider.selectedCategoryId == -1,
                      selectedColor: kPrimaryColor,
                      onSelected: (_) => _onCategorySelected(-1),
                    ),
                  ),
                  ...categoryProvider.categories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ChoiceChip(
                        label: Text(category.name),
                        selected:
                            categoryProvider.selectedCategoryId == category.id,
                        selectedColor: kPrimaryColor,
                        onSelected: (_) => _onCategorySelected(category.id),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // Subcategories (only shown when a main category is selected)
          Consumer<CategoryProvider>(
            builder: (context, categoryProvider, _) {
              if (categoryProvider.selectedCategoryId == -1 ||
                  categoryProvider.subcategories.isEmpty) {
                return const SizedBox.shrink();
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...categoryProvider.subcategories.map(
                      (subcategory) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ChoiceChip(
                            backgroundColor:
                                categoryProvider.selectedSubcategoryId ==
                                        subcategory.id
                                    ? kPrimaryColor
                                    : Colors.grey[200],
                            label: Text(subcategory.name),
                            selected: categoryProvider.selectedSubcategoryId ==
                                subcategory.id,
                            selectedColor: kPrimaryColor,
                            onSelected: (_) =>
                                _onSubCategorySelected(subcategory.id),
                          ),
                        );
                      },
                    )
                  ],
                ),
              );
            },
          ),

          // Products Grid
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.filteredProducts.isEmpty) {
                  return const Center(child: Text('No products found'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: provider.filteredProducts.length,
                  itemBuilder: (_, index) {
                    final product = provider.filteredProducts[index];
                    return ProductCard(
                      product: ProductModel(
                        id: product.id,
                        title: product.title,
                        description: '',
                        price: product.price,
                        image: product.image!,
                      ),
                      press: () => Navigator.pushNamed(
                        context,
                        ProductDetailScreen.routeName,
                        arguments:
                            ProductDetailsArgument(productId: product.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
