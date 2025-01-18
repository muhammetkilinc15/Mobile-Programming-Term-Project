import 'package:flutter/material.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/providers/product_provider.dart';
import 'package:miloo_mobile/screens/product_detail/components/body.dart';
import 'package:miloo_mobile/screens/product_detail/components/custom_app_bar.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});
  static String routeName = '/detail';

  @override
  State<ProductDetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<ProductDetailScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ProductDetailsArgument arguments =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArgument;
    context.read<ProductProvider>().getProductDetail(arguments.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            );
          }

          if (provider.detailError.isNotEmpty) {
            return Center(child: Text('Error: ${provider.detailError}'));
          }

          if (provider.productDetail == null) {
            return const Center(child: Text('No product details found'));
          }

          return Scaffold(
            appBar: CustomAppbar(views: provider.productDetail!.views),
            body: Body(product: provider.productDetail!),
          );
        },
      ),
    );
  }
}

class ProductDetailsArgument {
  final int productId;
  ProductDetailsArgument({required this.productId});
}
