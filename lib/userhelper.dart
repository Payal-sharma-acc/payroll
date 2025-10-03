import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:payrollapp/utils/token_storage.dart';


class UserHelper {
  static Future<String?> getUserNameFromToken() async {
    final token = await TokenStorage.getToken();
    if (token == null || token.isEmpty) return null;

    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      return decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"];
    } catch (e) {
      print("Error decoding token: $e");
      return null;
    }
  }
}
