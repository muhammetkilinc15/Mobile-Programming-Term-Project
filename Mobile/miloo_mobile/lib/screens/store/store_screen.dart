import 'package:flutter/material.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/screens/product/product_detail/product_detail_screen.dart';
import 'package:miloo_mobile/screens/store/components/subcategory_list.dart';
import 'package:provider/provider.dart';
import 'package:miloo_mobile/providers/category_provider.dart';
import 'package:miloo_mobile/providers/product_provider.dart';
import 'components/store_app_bar.dart';
import 'components/category_list.dart';
import 'components/product_list.dart';

class StoreScreen extends StatefulWidget {
  final int? initialCategoryId;
  const StoreScreen({super.key, this.initialCategoryId});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
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

      await categoryProvider.getCategories(pageNumber: 1, pageSize: 20);

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

  void _handleSort(String value) async {
    final categoryProvider = context.read<CategoryProvider>();
    final productProvider = context.read<ProductProvider>();

    await productProvider.getProducts(
      categoryId: categoryProvider.selectedCategoryId,
      subcategoryId: categoryProvider.selectedSubcategoryId,
      orderBy: value,
    );
  }

  void _navigateToProduct(int productId) {
    Navigator.pushNamed(
      context,
      ProductDetailScreen.routeName,
      arguments: ProductDetailsArgument(productId: productId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StoreAppBar(
        initialCategoryId: widget.initialCategoryId,
        currentSort: context.watch<ProductProvider>().sortBy,
        onSortChanged: _handleSort,
      ),
      body: Column(
        children: [
          Consumer<CategoryProvider>(
            builder: (_, provider, __) => CategoryList(
              categories: provider.categories,
              selectedCategoryId: provider.selectedCategoryId,
              onCategorySelected: _onCategorySelected,
            ),
          ),
          Consumer<CategoryProvider>(
            builder: (_, provider, __) {
              if (provider.selectedCategoryId == -1) {
                return const SizedBox.shrink();
              }
              return SubcategoryList(
                subcategories: provider.subcategories,
                selectedSubcategoryId: provider.selectedSubcategoryId,
                onSubcategorySelected: _onSubCategorySelected,
              );
            },
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (_, provider, __) {
                if (provider.isLoading) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ));
                }
                return ProductGrid(
                  products: provider.filteredProducts,
                  onProductTap: _navigateToProduct,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
