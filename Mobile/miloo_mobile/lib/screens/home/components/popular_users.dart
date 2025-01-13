import 'package:flutter/material.dart';
import 'package:miloo_mobile/screens/home/components/popular_user_card.dart';
import 'package:miloo_mobile/screens/user/user_detail_screen.dart';
import 'package:miloo_mobile/models/popular_user_model.dart';
import 'package:miloo_mobile/services/user_service.dart';
import 'package:shimmer/shimmer.dart'; // Shimmer importu

class PopularUsers extends StatefulWidget {
  const PopularUsers({super.key});

  @override
  State<PopularUsers> createState() => _PopularUsersState();
}

class _PopularUsersState extends State<PopularUsers> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PopularUserModel>>(
      future: UserService.getPopularUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(5, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        // Veriler geldiyse, popüler kullanıcıları gösteriyoruz
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<PopularUserModel> popularUsers = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: popularUsers.map((user) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PopularUserCard(
                    image: user.profileImageUrl,
                    fullName: user.userName,
                    press: () {
                      Navigator.pushNamed(
                        context,
                        UserDetailScreen.routeName,
                        arguments:
                            UserDetailScreenArguments(username: user.userName),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          );
        }

        // Veriler boşsa bir mesaj göster
        return const Center(child: Text('No popular users found.'));
      },
    );
  }
}
