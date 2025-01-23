import 'package:flutter/material.dart';
import 'package:miloo_mobile/models/users_model.dart';
import 'package:miloo_mobile/screens/user/user_detail/user_detail_screen.dart';
import 'package:miloo_mobile/providers/user_provider.dart';
import 'package:miloo_mobile/size_config.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUsers();
    });
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchUsers() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await context
          .read<UserProvider>()
          .getUsers(pageNumber: _currentPage, pageSize: _pageSize);
    } catch (e) {
      print('Error fetching users: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _currentPage++;
      });
      _fetchUsers();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        if (userProvider.isLoading && userProvider.users.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else if (userProvider.error.isNotEmpty) {
          return Center(child: Text('Error: ${userProvider.error}'));
        } else if (userProvider.users.isEmpty) {
          return const Center(child: Text('No users found'));
        } else {
          List<UsersModel> users = userProvider.users;

          return ListView.builder(
            controller: _scrollController,
            itemCount: users.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == users.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final user = users[index];
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    UserDetailScreen.routeName,
                    arguments:
                        UserDetailScreenArguments(username: user.userName),
                  );
                },
                child: Card(
                  color: Colors.grey[50],
                  margin: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(8),
                      horizontal: getProportionateScreenWidth(16)),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.all(getProportionateScreenWidth(8)),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.image),
                      radius: 30,
                    ),
                    title: Text(
                      '${user.firstName} ${user.lastName}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
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
