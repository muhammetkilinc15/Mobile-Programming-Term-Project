import 'package:flutter/material.dart';
import 'package:miloo_mobile/models/category_model.dart';
import 'package:miloo_mobile/screens/home/components/category_card.dart';
import 'package:miloo_mobile/screens/store/store_screen.dart';
import 'package:miloo_mobile/services/category_service.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  // Future olan bir kategori veri kaynağını almak için
  late Future<List<CategoryModel>> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories =
        CategoryService.getCategories(pageNumber: 1, pageSize: 5);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    futureCategories =
        CategoryService.getCategories(pageNumber: 1, pageSize: 5);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoryModel>>(
      future: futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Eğer veri bekleniyorsa, bir yükleniyor göstergesi gösterebiliriz
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Eğer hata varsa, hatayı göster
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Eğer veri yoksa, kategori bulunamadı yazabiliriz
          return Text('No categories found');
        } else {
          List<CategoryModel> categories = snapshot.data!;

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
                    icon: Icons
                        .gamepad, // İkonu istediğiniz gibi değiştirebilirsiniz
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
