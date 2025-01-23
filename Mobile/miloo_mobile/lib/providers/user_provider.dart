import 'package:flutter/material.dart';
import 'package:miloo_mobile/models/popular_user_model.dart';
import 'package:miloo_mobile/models/user_detail_model.dart';
import 'package:miloo_mobile/models/user_with_product_detail.dart';
import 'package:miloo_mobile/models/users_model.dart';
import 'package:miloo_mobile/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();

  List<PopularUserModel> popularUsers = [];
  List<UsersModel> users = [];
  UserDetailModel? userDetail;
  UserWithProductDetail? userWithProductDetail;
  bool isLoading = false;
  String error = '';

  @override
  void dispose() {
    clearData();
    super.dispose();
  }

  void clearData() {
    popularUsers.clear();
    users.clear();
    userDetail = null;
    userWithProductDetail = null;
    error = '';
    notifyListeners();
  }

// Get popular users
  Future<void> getPopularUsers({int top = 5}) async {
    if (isLoading) return;

    try {
      isLoading = true;
      notifyListeners();
      popularUsers = await _userService.getPopularUsers(top: top);
      error = '';
    } catch (e) {
      error = e.toString();
      print('Error fetching popular users: $e'); // Debug log
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

// Get users
  Future<void> getUsers({int pageNumber = 1, int pageSize = 9}) async {
    try {
      isLoading = true;
      notifyListeners();
      users = await _userService.getUsers(
          pageNumber: pageNumber, pageSize: pageSize);
      error = '';
    } catch (e) {
      error = e.toString();
      print('Error fetching users: $e'); // Debug log
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

// Get user with product detail by username
  Future<void> getUserWithProductDetail(String username) async {
    try {
      isLoading = true;
      notifyListeners();
      userWithProductDetail =
          await _userService.getUserWithProductDetail(username);
      error = '';
    } catch (e) {
      error = e.toString();
      print('Error fetching user with product detail: $e'); // Debug log
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

// Get user detail
  Future<void> getUserDetail() async {
    try {
      isLoading = true;
      notifyListeners();
      userDetail = await _userService.getUserDetail();
      error = '';
    } catch (e) {
      error = e.toString();
      print('Error fetching user detail: $e'); // Debug log
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

// Update user info
  Future<void> updateUserInfo({
    required String profileImage,
    required String userName,
    required String firstName,
    required String lastName,
    required int universityId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      await _userService.updateUserInfo(
        profileImage: profileImage,
        userName: userName,
        firstName: firstName,
        lastName: lastName,
        universityId: universityId,
      );
      await getUserDetail(); // Refresh user detail
      error = '';
    } catch (e) {
      error = e.toString();
      print('Error updating user info: $e'); // Debug log
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    error = '';
    notifyListeners();
  }
}
