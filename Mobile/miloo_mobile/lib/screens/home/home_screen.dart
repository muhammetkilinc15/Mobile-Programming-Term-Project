import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:miloo_mobile/screens/chat/chat_screen.dart';
import 'package:miloo_mobile/screens/home/components/body.dart';
import 'package:miloo_mobile/size_config.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          leading: Padding(
            padding: EdgeInsets.only(left: getProportionateScreenWidth(10)),
            child: SvgPicture.asset(
              'assets/logo/Shoplon.svg',
              width: getProportionateScreenWidth(50),
              height: getProportionateScreenHeight(50),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: CustomSearchDelegate());
              },
            ),
            IconButton(
              icon: const Icon(Icons.message_outlined),
              onPressed: () {
                Navigator.pushNamed(context, ChatScreen.routeName);
              },
            ),
          ],
        ),
        body: const Body());
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchResults = [
    'Clothes',
    'Shoes',
    'Accessories',
    'Bags',
    'Watches',
    'Jewelry',
  ];

  bool isLoading = false;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in searchResults) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return isLoading
        ? buildLoadingSkeleton()
        : ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(matchQuery[index]),
              );
            },
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    if (query.isNotEmpty) {
      for (var item in searchResults) {
        if (item.toLowerCase().contains(query.toLowerCase())) {
          matchQuery.add(item);
        }
      }
    }
    return isLoading
        ? buildLoadingSkeleton()
        : ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(matchQuery[index]),
              );
            },
          );
  }

  @override
  void showResults(BuildContext context) {
    isLoading = true;
    Future.delayed(const Duration(seconds: 2), () {
      isLoading = false;
      super.showResults(context);
    });
  }

  Widget buildLoadingSkeleton() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            title: Container(
              width: double.infinity,
              height: 16.0,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
