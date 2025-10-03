import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:payrollapp/Models/employeeloginmodel.dart';
import 'package:payrollapp/Pages/employeedashboard.dart';
import 'package:payrollapp/Workflows/employeeshiftworkflow.dart';
import 'package:payrollapp/utils/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payrollapp/Workflows/employeeloginworkflow.dart';
import 'package:payrollapp/Models/biometricattendancemodel.dart';
import 'package:payrollapp/Workflows/biomatricattendanceworkflow.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class Employeelogin extends StatefulWidget {
  const Employeelogin({super.key});

  @override
  State<Employeelogin> createState() => _EmployeeloginState();
}

Map<String, dynamic> parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) throw Exception('Invalid token');
  final payload = base64Url.normalize(parts[1]);
  final payloadMap = json.decode(utf8.decode(base64Url.decode(payload)));
  if (payloadMap is! Map<String, dynamic>) throw Exception('Invalid payload');
  return payloadMap;
}

class _EmployeeloginState extends State<Employeelogin> {
  final TextEditingController emailPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  final LocalAuthentication auth = LocalAuthentication();
  final AttendanceWorkflow _workflow = AttendanceWorkflow();
  Future<bool> requestLocationPermission() async {
    bool foregroundGranted = await Permission.location.request().isGranted;
    bool backgroundGranted =
        await Permission.locationAlways.request().isGranted;

    if (!foregroundGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Foreground location permission is required."),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (!backgroundGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Background location permission is required."),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (!backgroundGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Background location permission is required."),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }
Future<void> navigateToemployeelogin(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isEmployeeLoggedIn = prefs.getBool("isEmployeeLoggedIn") ?? false;

  if (isEmployeeLoggedIn) {
 
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Employeedashboard()),
    );
  } else {
  
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Employeelogin()),
    );
  }
}
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
  Future<void> _startBiometricAttendance(int employeeId) async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: "Please verify your fingerprint to mark attendance",
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Biometric Attendance',
            cancelButton: 'Cancel',
            biometricHint: 'Touch the sensor',
          ),
        ],
        options: const AuthenticationOptions(
          
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      if (!authenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Biometric authentication failed ❌"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      bool hasPermission = await requestLocationPermission();
      if (!hasPermission) return;

      Position position;
      try {
        position = await _getCurrentLocation();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Location error: $e"),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final shifts = await Employeeshift.getAllShifts();
      final shift = shifts.isNotEmpty ? shifts.first : null;

      if (shift == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No shift assigned."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final now = DateTime.now();
      final outTime = now.add(const Duration(hours: 9));
      final duration = outTime.difference(now);
      final totalHours =
          "${duration.inHours}h ${duration.inMinutes.remainder(60)}m";

      final attendanceModel = Biomatricattendancemodel(
        employeeId: employeeId,
        attendanceDate: now,
        inTime: now,
        outTime: outTime,
        totalHours: totalHours,
        status: "Present",
        workType: "provision",
        shiftId: shift.id,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      await _workflow.createAttendance(attendanceModel);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Attendance marked successfully "),

          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Employeedashboard()),
      );
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Biometric error: ${e.message}"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }
  void _handleLogin() async {
    final contact = emailPhoneController.text.trim();
    final password = passwordController.text.trim();

    if (contact.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter both email and password."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final loginModel = EmployeeLoginModel(email: contact, password: password);
      final loginWorkflow = EmployeeLoginWorkflow();
      final loginResponse = await loginWorkflow.login(loginModel);

      setState(() => _isLoading = false);

      if (loginResponse == null || loginResponse.token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please check your credentials."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      int companyId = loginResponse.companyId ?? 0;
      final payload = parseJwt(loginResponse.token!);
      final latitude =
          double.tryParse(payload['Latitude']?.toString() ?? '0') ?? 0;
      final longitude =
          double.tryParse(payload['Longitude']?.toString() ?? '0') ?? 0;

      if (companyId == 0) {
        companyId = int.tryParse(payload['CompanyId']?.toString() ?? '0') ?? 0;
      }

      if (companyId > 0) {
        await TokenStorage.saveCompanyId(companyId);
        print("✅ Company ID saved: $companyId");
      } else {
        print("❌ Company ID missing in both response & token");
      }
      await TokenStorage.saveToken(
        loginResponse.token!,
        latitude: latitude,
        longitude: longitude,
        companyId: companyId,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isEmployeeLoggedIn", true);
      await prefs.setInt("employeeId", loginResponse.employeeId ?? 0);
      await prefs.setString(
        "employeeName",
        loginResponse.fullName ?? "Employee",
      );
      await prefs.setString("employeeEmail", loginResponse.email ?? "");
      if (loginResponse.employeeId != null) {
        await _startBiometricAttendance(loginResponse.employeeId!);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login successful!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please check your credentials."),
          backgroundColor: Colors.red,
        ),
      );
      print("⚠️ Login error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color.fromARGB(255, 218, 250, 253)],
            stops: [0.3, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('lib/assets/employeeimg.png', height: 250),
                  const SizedBox(height: 20),
                  const Text(
                    "Hi, Welcome! 👋",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: emailPhoneController,
                    decoration: InputDecoration(
                      hintText: "Your email",
                      labelText: "Email address",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: "Password",
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0057FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "Log in",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
