import 'package:flutter/material.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/models/user_products_model.dart';
import 'package:miloo_mobile/size_config.dart';
import 'package:provider/provider.dart';
import 'package:miloo_mobile/providers/product_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class Body extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().getUserProducts();
    });
  }

  Future<void> _deleteProduct(int id) async {
    try {
      await context.read<ProductProvider>().deleteProduct(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product deleted successfully'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to delete product: $e'),
            duration: const Duration(seconds: 1),
            backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _markAsSold(int id) async {
    try {
      await context.read<ProductProvider>().markAsSold(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Product marked as sold'),
            backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to mark product as sold: $e'),
            backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _editProduct(UserProductsModel product) async {
    final TextEditingController titleController =
        TextEditingController(text: product.title);
    final TextEditingController priceController =
        TextEditingController(text: product.price.toString());

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            SizedBox(
              height: getProportionateScreenHeight(20),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
          TextButton(
            onPressed: () async {
              await context.read<ProductProvider>().updateProduct(
                    id: product.id,
                    title: titleController.text,
                    price: double.parse(priceController.text),
                  );
              Navigator.pop(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(color: kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        if (productProvider.isLoading && productProvider.userProducts.isEmpty) {
          return const Center(
              child: CircularProgressIndicator(
            color: kPrimaryColor,
          ));
        } else if (productProvider.error.isNotEmpty) {
          return Center(child: Text('Error: ${productProvider.error}'));
        } else if (productProvider.userProducts.isEmpty) {
          return const Center(child: Text('No products found'));
        }
        return ListView.builder(
          itemCount: productProvider.userProducts.length,
          itemBuilder: (context, index) {
            final product = productProvider.userProducts[index];
            return Card(
              color: Colors.grey[100],
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: product.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[300],
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (product.isSold)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'SOLD',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editProduct(product),
                    ),
                    if (!product.isSold)
                      IconButton(
                        icon: const Icon(Icons.playlist_add_check_rounded,
                            color: Colors.green),
                        onPressed: () => _markAsSold(product.id),
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteProduct(product.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
