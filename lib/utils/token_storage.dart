import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TokenStorage {
  //  Save EMPLOYEE token + decode and store claims
  static Future<void> saveToken(
    String token, {
    double? latitude,
    double? longitude,
    int? companyId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);

    try {
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      final id = decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"];
      final name = decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"];
      final email = decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"];
      final role = decodedToken["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"];
      final compId = decodedToken["CompanyId"];
      final lat = decodedToken["Latitude"] ?? decodedToken["Latitide"]; // handle both spellings
      final long = decodedToken["Longitude"];

      if (id != null) await saveEmployeeId(int.tryParse(id) ?? 0);
      if (name != null) await saveFullName(name);
      if (email != null) await saveEmail(email);
      if (role != null) await saveRole(role);
      if (compId != null) await saveCompanyId(int.tryParse(compId) ?? 0);
      if (lat != null) await saveLatitude(double.tryParse(lat) ?? 0.0);
      if (long != null) await saveLongitude(double.tryParse(long) ?? 0.0);

    } catch (e) {
      print("⚠️ Employee token decode failed: $e");
    }

    // Preserve explicit params if passed
    if (latitude != null) await prefs.setDouble('latitude', latitude);
    if (longitude != null) await prefs.setDouble('longitude', longitude);
    if (companyId != null) await prefs.setInt('companyId', companyId);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  //  Save ADMIN token + decode and store claims
  static Future<void> saveAdminToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('adminToken', token);

    try {
      final decodedToken = JwtDecoder.decode(token);

      final id = decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"];
      final name = decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"];
      final email = decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"];
      final role = decodedToken["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"];
      final compId = decodedToken["CompanyId"];
      final lat = decodedToken["Latitude"] ?? decodedToken["Latitide"];
      final long = decodedToken["Longitude"];

      if (id != null) await saveAdminUserId(int.tryParse(id) ?? 0);
      if (name != null) await saveFullName(name);
      if (email != null) await saveEmail(email);
      if (role != null) await saveRole(role);
      if (compId != null) await saveCompanyId(int.tryParse(compId) ?? 0);
      if (lat != null) await saveLatitude(double.tryParse(lat) ?? 0.0);
      if (long != null) await saveLongitude(double.tryParse(long) ?? 0.0);

    } catch (e) {
      print("⚠️ Admin token decode failed: $e");
    }
  }

  static Future<String?> getAdminToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('adminToken');
  }

  static Future<void> saveAdminUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('adminUserId', userId);
  }

  static Future<int?> getAdminUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('adminUserId');
  }

  static Future<void> saveResetToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('resetToken', token);
  }

  static Future<String?> getResetToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('resetToken');
  }

  static Future<void> clearResetToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('resetToken');
  }

  static Future<void> saveRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('refreshToken', token);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  static Future<void> clearRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('refreshToken');
  }

  // 🔹 Clear all tokens + related info
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('adminToken');
    await prefs.remove('adminUserId');
    await prefs.remove('resetToken');
    await prefs.remove('refreshToken');
    await prefs.remove('orgId');
    await prefs.remove('latitude');
    await prefs.remove('longitude');
    await prefs.remove('employeeId');
    await prefs.remove('fullName');
    await prefs.remove('companyId');
    await prefs.remove('email');
    await prefs.remove('role');
  }

  //  OrgId
  static Future<void> saveOrgId(int orgId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('orgId', orgId);
  }

  static Future<int?> getOrgId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('orgId');
  }

  //  Latitude
  static Future<void> saveLatitude(double latitude) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', latitude);
  }

  static Future<double?> getLatitude() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('latitude');
  }

  //  Longitude
  static Future<void> saveLongitude(double longitude) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('longitude', longitude);
  }

  static Future<double?> getLongitude() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('longitude');
  }

  //  EmployeeId
  static Future<void> saveEmployeeId(int employeeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('employeeId', employeeId);
  }

  static Future<int?> getEmployeeId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('employeeId');
  }

  //  Full Name
  static Future<void> saveFullName(String fullName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', fullName);
  }

  static Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fullName');
  }

  //  Email
  static Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  // Role
  static Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  //  CompanyId
  static Future<void> saveCompanyId(int companyId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('companyId', companyId);
  }

  static Future<int?> getCompanyId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('companyId');
  }
}
