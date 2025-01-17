import 'package:flutter/material.dart';
import 'package:miloo_mobile/models/users_model.dart';
import 'package:miloo_mobile/screens/user_detail/user_detail_screen.dart';
import 'package:miloo_mobile/services/user_service.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final ScrollController _scrollController = ScrollController();
  List<UsersModel> _users = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 10;
  final UserService _userService = UserService();
  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsers() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final newUsers = await _userService.getUsers(
          pageNumber: _currentPage, pageSize: _pageSize);
      setState(() {
        _users.addAll(newUsers);
        _currentPage++;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _users.isEmpty && _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            controller: _scrollController,
            itemCount: _users.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _users.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final user = _users[index];
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, UserDetailScreen.routeName,
                      arguments:
                          UserDetailScreenArguments(username: user.userName));
                },
                child: ListTile(
                  title: Text(user.firstName),
                  subtitle: Text(user.lastName),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.image),
                  ),
                ),
              );
            },
          );
  }
}
