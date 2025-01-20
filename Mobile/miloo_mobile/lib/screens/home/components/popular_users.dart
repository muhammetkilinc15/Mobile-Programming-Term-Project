import 'package:flutter/material.dart';
import 'package:miloo_mobile/providers/user_provider.dart';
import 'package:miloo_mobile/screens/home/components/popular_user_card.dart';
import 'package:miloo_mobile/screens/user_detail/user_detail_screen.dart';
import 'package:miloo_mobile/models/popular_user_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart'; // Shimmer importu

class PopularUsers extends StatefulWidget {
  const PopularUsers({super.key});

  @override
  State<PopularUsers> createState() => _PopularUsersState();
}

class _PopularUsersState extends State<PopularUsers> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getPopularUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.isLoading && userProvider.popularUsers.isEmpty) {
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
        } else if (userProvider.error.isNotEmpty) {
          return Center(child: Text('Error: ${userProvider.error}'));
        } else if (userProvider.popularUsers.isEmpty) {
          return const Center(child: Text('No popular users found'));
        } else {
          List<PopularUserModel> popularUsers = userProvider.popularUsers;

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
      },
    );
  }
}
