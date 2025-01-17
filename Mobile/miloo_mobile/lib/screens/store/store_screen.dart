import 'package:flutter/material.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/models/category_model.dart';
import 'package:miloo_mobile/models/popular_product_model.dart';
import 'package:miloo_mobile/screens/product_detail/product_detail_screen.dart';
import 'package:miloo_mobile/services/category_service.dart';
import 'package:miloo_mobile/services/product_service.dart';
import 'package:shimmer/shimmer.dart';

class StoreScreen extends StatefulWidget {
  final int? initialCategoryId; // Başlangıç kategorisi ID
  const StoreScreen({
    super.key,
    this.initialCategoryId,
  });

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  int selectedCategoryId = -1; // Varsayılan kategori ID
  String sortBy = 'popular'; // Varsayılan sıralama kriteri
  List<CategoryModel> categories = [];
  List<PopularProductModel> products = [];
  bool isLoadingProducts = false;
  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService();
  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadProducts({
    int categoryId = -1,
    String orderBy = 'popular',
  }) async {
    setState(() {
      isLoadingProducts = true;
    });

    try {
      List<PopularProductModel> fetchedProducts =
          await _productService.getProducts(
        universityId: 1,
        categoryId: categoryId,
        orderBy: orderBy,
      );

      setState(() {
        products = fetchedProducts;
      });
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      setState(() {
        isLoadingProducts = false;
      });
    }
  }

  Future<void> _loadCategories() async {
    try {
      List<CategoryModel> fetchedCategories =
          await _categoryService.getCategories(pageNumber: 1, pageSize: 10);

      fetchedCategories.insert(
          0, CategoryModel(id: -1, name: 'All')); // "All" kategorisi ekleniyor
      setState(() {
        categories = fetchedCategories;
        selectedCategoryId = widget.initialCategoryId ?? -1;
        _loadProducts(categoryId: selectedCategoryId, orderBy: sortBy);
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        actions: [
          DropdownButton<String>(
            value: sortBy,
            underline: const SizedBox(),
            icon: const Icon(Icons.sort, color: Colors.white),
            items: const [
              DropdownMenuItem(value: 'popular', child: Text('Popular')),
              DropdownMenuItem(value: 'price', child: Text('Price')),
              DropdownMenuItem(value: 'newest', child: Text('Newest')),
              DropdownMenuItem(value: 'university', child: Text('University')),
            ],
            onChanged: (value) {
              setState(() {
                sortBy = value!;
                _loadProducts(categoryId: selectedCategoryId, orderBy: sortBy);
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Kategori Seçimi
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                final isSelected = selectedCategoryId == category.id;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    label: Text(category.name),
                    selected: isSelected,
                    selectedColor: kPrimaryColor,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategoryId = category.id;
                        _loadProducts(categoryId: category.id, orderBy: sortBy);
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),

          // Ürünler
          Expanded(
            child: isLoadingProducts
                ? Shimmer.fromColors(
                    period: const Duration(seconds: 5),
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) => ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          color: Colors.white,
                        ),
                        title: Container(
                          width: double.infinity,
                          height: 10,
                          color: Colors.white,
                        ),
                        subtitle: Container(
                          width: double.infinity,
                          height: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : products.isEmpty
                    ? const Center(child: Text('No products available.'))
                    : ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ListTile(
                            leading: Image.network(product.image!),
                            title: Text(product.title),
                            subtitle: Text('\$${product.price}'),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, ProductDetailScreen.routeName,
                                  arguments: ProductDetailsArgument(
                                    productId: product.id,
                                  ));
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
