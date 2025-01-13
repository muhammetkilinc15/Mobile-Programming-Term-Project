import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final storage = FlutterSecureStorage();

Future<List<String>?> getUserRole() async {
  String? token = await storage.read(key: 'accessToken');

  if (token != null) {
    // Token'ı decode et
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    // Eğer 'roles' bir dizi ise doğrudan döndürebiliriz
    if (decodedToken['roles'] is List) {
      return List<String>.from(decodedToken['roles']);
    }

    // Eğer 'roles' bir string ise, onu tek elemanlı bir liste olarak döndür
    if (decodedToken['roles'] is String) {
      return [decodedToken['roles']];
    }
  }
  return null;
}
