import 'package:flutter/material.dart';
import 'package:miloo_mobile/size_config.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<String> categories = [
    'Clothes',
    'Shoes',
    'Accessories',
    'Bags',
    'Watches',
    'Jewelry',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: getProportionateScreenHeight(30),
          child: Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Butona basıldığında yapılacak işlemler
                      print('Selected category: ${categories[index]}');
                    },
                    child: Text(categories[index]),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
