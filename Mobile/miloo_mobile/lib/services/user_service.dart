import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:http/http.dart' as http;
import 'package:miloo_mobile/models/popular_user_model.dart';
import 'package:miloo_mobile/models/user_detail_model.dart';
import 'package:miloo_mobile/models/user_with_product_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const url = "${baseUrl}User";

  static Future<List<PopularUserModel>> getPopularUsers() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: "accessToken");
    if (token == null) {
      throw Exception("Token not found");
    }
    int userId = int.parse(JwtDecoder.decode(token)["userId"]);

    final response =
        await http.get(Uri.parse("$url/popular-users?userId=$userId"));

    if (response.statusCode == 200) {
      List<dynamic> popularUsersJson = jsonDecode(response.body) as List;
      List<PopularUserModel> popularUsers = popularUsersJson
          .map((user) => PopularUserModel.fromJson(user))
          .toList();
      return popularUsers;
    } else {
      print('Error: ${response.statusCode} - ${response.reasonPhrase}');
      throw Exception("Bağlantı hatası oluştu");
    }
  }

  static Future<UserWithProductDetail> getUserWithProductDetail(
      String username) async {
    var response =
        await http.get(Uri.parse("$url/user-info-with-product/$username"));

    if (response.statusCode == 200) {
      var userWithProductDetail = jsonDecode(response.body);
      return UserWithProductDetail.fromJson(userWithProductDetail);
    } else {
      throw Exception("Bağlantı hatası oluştu");
    }
  }

  static Future<UserDetailModel> getUserDetail() async {
    const storege = FlutterSecureStorage();
    final token = await storege.read(key: "accessToken");
    if (token == null) {
      throw Exception("Token not found");
    }
    int userId = int.parse(JwtDecoder.decode(token)["userId"]);
    final response = await http.get(Uri.parse("$url/user-info/$userId"));
    if (response.statusCode == 200) {
      var userDetail = jsonDecode(response.body);
      return UserDetailModel.fromJson(userDetail);
    } else {
      throw Exception("Bağlantı hatası oluştu");
    }
  }

  static Future<String> updateUserInfo({
    required String profileImage,
    required String userName,
    required String firstName,
    required String lastName,
    required int universityId,
  }) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: "accessToken");
    if (token == null) {
      throw Exception("Token not found");
    }
    int userId = int.parse(JwtDecoder.decode(token)["userId"]);

    var request = http.MultipartRequest('PUT', Uri.parse("$url/update"));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['UserId'] = userId.toString();
    request.fields['UserName'] = userName;
    request.fields['FirstName'] = firstName;
    request.fields['LastName'] = lastName;
    request.fields['UniversityId'] = universityId.toString();

    print('Profile image: $profileImage');

    if (profileImage.isNotEmpty) {
      request.files
          .add(await http.MultipartFile.fromPath('ProfileImage', profileImage));
    }
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      print('Response string: $responseString');

      try {
        final responseData = jsonDecode(responseString);
        var profileImageUrl = responseData['profileImageUrl'];

        // URL'deki ters eğik çizgileri düzelt
        profileImageUrl = profileImageUrl?.replaceAll(r'\\', '/');
        print('Formatted Profile Image URL: $profileImageUrl');

        final prefs = await SharedPreferences.getInstance();
        prefs.setString("profileImage", profileImageUrl);

        return "User updated successfully";
      } catch (e) {
        print('Error parsing response: $e');
        throw Exception('Failed to parse response');
      }
    } else {
      final errorResponse = await response.stream.bytesToString();
      print('Error updating user: ${response.statusCode}');
      print('Response: $errorResponse');
      throw Exception('Failed to update user: ${response.statusCode}');
    }
  }
}
