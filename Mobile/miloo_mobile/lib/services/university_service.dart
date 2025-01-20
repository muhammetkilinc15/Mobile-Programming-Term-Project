import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/helper/token_manager.dart';
import 'package:miloo_mobile/models/university_model.dart';

class UniversityService {
  final String url = "${baseUrl}University/";
  final TokenManager tokenManager = TokenManager();
  Future<List<University>> getUniversity() async {
    final response = await http.get(
      Uri.parse("${url}getall?PageNumber=1&PageSize=120"),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      List<dynamic> data = jsonResponse['data'];
      List<University> universities =
          data.map((university) => University.fromJson(university)).toList();
      return universities;
    } else {
      throw Exception('Failed to load universities');
    }
  }

  Future<void> createUniversity(University university) async {
    final token = await tokenManager.getAccessToken();
    final response = await http.post(
      Uri.parse("${url}create"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(university.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create university');
    }
  }
}
