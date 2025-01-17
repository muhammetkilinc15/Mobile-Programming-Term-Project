import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:miloo_mobile/components/default_button.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/services/product_service.dart';
import 'package:miloo_mobile/models/user_products_model.dart'; // Assuming this is the correct model
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<List<UserProductsModel>> _userProductsFuture;
  ProductService _productService = ProductService();
  @override
  void initState() {
    super.initState();
    _userProductsFuture = _productService.getUserProducts();
  }

  Future<void> _deleteProduct(int id) async {
    try {
      await _productService.deleteProduct(id);
      setState(() {
        _userProductsFuture = _productService.getUserProducts();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product: $e')),
      );
    }
  }

  Future<void> _markAsSold(int id) async {
    try {
      await _productService.markAsSold(id);
      setState(() {
        _userProductsFuture = _productService.getUserProducts();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product marked as sold')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark product as sold: $e')),
      );
    }
  }

  Future<void> _update(int id, String title, double price) async {
    _productService.updateProduct(
      id: id,
      title: title,
      price: price,
    );
    setState(() {
      _userProductsFuture = _productService.getUserProducts();
    });
  }

  void _editProduct(UserProductsModel product) {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 247, 241, 233),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final titleController = TextEditingController(text: product.title);
        final priceController =
            TextEditingController(text: product.price.toString());
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DefaultButton(
                  text: "Update",
                  press: () {
                    _update(
                      product.id,
                      titleController.text,
                      double.parse(priceController.text),
                    );
                    Navigator.pop(context);
                  })
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserProductsModel>>(
      future: _userProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products found.'));
        } else {
          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                color: Colors.grey[50],
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: product.image,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.white,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              cacheManager: CacheManager(
                                Config(
                                  'customCacheKey',
                                  stalePeriod: const Duration(hours: 1),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimaryColor,
                                  ),
                                ),
                                if (product.isSold)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'Sold',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              label: const Text('Edit',
                                  style: TextStyle(color: Colors.blue)),
                              onPressed: () => _editProduct(product),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              label: const Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () => _deleteProduct(product.id),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              icon:
                                  const Icon(Icons.check, color: Colors.green),
                              label: const Text('Mark as Sold',
                                  style: TextStyle(
                                    color: Colors.green,
                                  )),
                              onPressed: () => _markAsSold(product.id),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
