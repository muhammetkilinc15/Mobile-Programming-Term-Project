import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:miloo_mobile/constraits/constrait.dart';
import 'package:miloo_mobile/models/university_model.dart';

class UniversityService {
  final String url = "${baseUrl}University/";

  Future<List<University>> getUniversity() async {
    final response =
        await http.get(Uri.parse("${url}getall?PageNumber=1&PageSize=120"));

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
}

/*
{
  "data": [
    {
      "id": 1,
      "name": "Adana Alparslan Türkeş Bilim Ve Teknoloji Üniversitesi"
    },
    {
      "id": 2,
      "name": "Adıyaman Üniversitesi"
    },
    {
      "id": 3,
      "name": "Afyon Kocatepe Üniversitesi"
    },
    {
      "id": 4,
      "name": "Ağrı İbrahim Çeçen Üniversitesi"
    },
    {
      "id": 5,
      "name": "Ahi Evran Üniversitesi"
    },
    {
      "id": 6,
      "name": "Aksaray Üniversitesi"
    },
    {
      "id": 7,
      "name": "Amasya Üniversitesi"
    },
    {
      "id": 8,
      "name": "Anadolu Üniversitesi"
    },
    {
      "id": 9,
      "name": "Ankara Hacı Bayram Veli Üniversitesi"
    },
    {
      "id": 10,
      "name": "Ankara Üniversitesi"
    },
    {
      "id": 11,
      "name": "Ardahan Üniversitesi"
    },
    {
      "id": 12,
      "name": "Artvin Çoruh Üniversitesi"
    },
    {
      "id": 13,
      "name": "Atatürk Üniversitesi"
    },
    {
      "id": 14,
      "name": "Balıkesir Üniversitesi"
    },
    {
      "id": 15,
      "name": "Bartın Üniversitesi"
    }
  ],
  "pageInfo": {
    "_PageNumber": 1,
    "_PageSize": 15,
    "_TotalRowCount": 85,
    "totalPageCount": 6,
    "hasNextPage": true,
    "hasPreviousPage": false
  }
}
*/