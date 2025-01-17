import 'package:flutter/material.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/screens/product_detail/components/body.dart';
import 'package:miloo_mobile/screens/product_detail/components/custom_app_bar.dart';
import 'package:miloo_mobile/services/product_service.dart';
import 'package:miloo_mobile/models/product_detail_model.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});
  static String routeName = '/detail';

  @override
  State<ProductDetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<ProductDetailScreen> {
  late Future<ProductDetailModel> futureProductDetail;
  final ProductService _productService = ProductService();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchProductDetails();
  }

  @override
  void didUpdateWidget(covariant ProductDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _fetchProductDetails();
  }

  void _fetchProductDetails() {
    final ProductDetailsArgument arguments =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArgument;
    setState(() {
      futureProductDetail =
          _productService.getProductDetail(arguments.productId);
    });
    _productService.increaseView(arguments.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      body: FutureBuilder<ProductDetailModel>(
        future: futureProductDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: kPrimaryColor,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No product details found'));
          } else {
            return Scaffold(
              appBar: CustomAppbar(views: snapshot.data!.views),
              body: Body(product: snapshot.data!),
            );
          }
        },
      ),
    );
  }
}

class ProductDetailsArgument {
  final int productId;
  ProductDetailsArgument({required this.productId});
}
