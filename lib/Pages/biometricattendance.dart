import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:payrollapp/Models/biometricattendancemodel.dart';
import 'package:payrollapp/Workflows/biomatricattendanceworkflow.dart';
import 'package:payrollapp/utils/token_storage.dart';

class BiometricAttendancePage extends StatefulWidget {
  @override
  _BiometricAttendancePageState createState() =>
      _BiometricAttendancePageState();
}

class _BiometricAttendancePageState extends State<BiometricAttendancePage> {
  final LocalAuthentication auth = LocalAuthentication();
  final AttendanceWorkflow _workflow = AttendanceWorkflow();

  bool _canCheckBiometrics = false;
  List<BiometricType> _availableBiometrics = [];
  String _authStatus = 'Authentication not started.';
  bool _isAuthenticated = false;
  int? _currentAttendanceId;

  bool _isPunchedIn = false;
  DateTime? _punchInTime;
  DateTime? _punchOutTime;

  Position? _currentPosition;
  String? _address;
  int? employeeId;

  String username = 'Your Name Here';

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
    _fetchEmployeeName();
    _loadEmployeeId();
  }

  Future<void> _loadEmployeeId() async {
    final id = await TokenStorage.getEmployeeId();
    if (id != null) {
      setState(() => employeeId = id);
    } else {
      print("❌ EmployeeId not found. User may need to login.");
    }
  }

  Future<void> _fetchEmployeeName() async {
    try {
      setState(() {
        username = "Decoded User Name";
      });
    } catch (e) {
      print("Error fetching username: $e");
    }
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });

    if (_canCheckBiometrics) {
      _getAvailableBiometrics();
    }
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String?> _getAddressFromCoordinates(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return "Plot No. ${place.street}, ${place.locality}, ${place.subLocality},  pin code:${place.postalCode}";
      }
      return 'Address not found';
    } catch (e) {
      print(e);
      return 'Could not get address';
    }
  }

  Future<void> _authenticate() async {
    bool authenticated = false;

    setState(() {
      _authStatus = 'Fetching location...';
    });

    try {
      _currentPosition = await _getCurrentLocation();
      if (_currentPosition == null) {
        setState(() {
          _authStatus = 'Could not get location. Please try again.';
        });
        return;
      }

      _address = await _getAddressFromCoordinates(_currentPosition!);
    } catch (e) {
      setState(() {
        _authStatus = e.toString();
      });
      return;
    }

    try {
      setState(() {
        _authStatus = 'Authenticating...';
      });
      authenticated = await auth.authenticate(
        localizedReason:
            _isPunchedIn
                ? 'Please place your finger to Punch Out.'
                : 'Please place your finger to Punch In.',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Biometric Attendance',
            biometricHint: 'Verify your identity to proceed',
            cancelButton: 'Cancel',
            goToSettingsButton: 'Settings',
            goToSettingsDescription:
                'Please enroll a biometric credential in your device settings.',
          ),
        ],
        options: const AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _authStatus = 'Authentication failed: ${e.message}';
      });
      return;
    }
    if (!mounted) return;

    if (!authenticated) {
      setState(() {
        _authStatus = 'Authentication cancelled.';
      });
      return;
    }

    setState(() {
      _isAuthenticated = true;
    });
    if (!_isPunchedIn) {
      _punchInTime = DateTime.now();
      _punchOutTime = null;
      _isPunchedIn = true;
      _authStatus = 'Punched In successfully!';

      final model = Biomatricattendancemodel(
        employeeId: employeeId,
        attendanceDate: _punchInTime,
        inTime: _punchInTime,
        status: "Present",
        workType: "provision",
        shiftId: 1,
        latitude: _currentPosition?.latitude,
        longitude: _currentPosition?.longitude,
      );

      _workflow
          .createAttendance(model)
          .then((res) {
            print("✅ Attendance Created: ${res?.attendanceId}");
            if (res?.attendanceId != null) {
              _currentAttendanceId = res!.attendanceId;
            }
          })
          .catchError((err) {
            print("❌ Create error: $err");
          });
    }
    else {
      _punchOutTime = DateTime.now();
      _isPunchedIn = false;
      _authStatus = 'Punched Out successfully!';

      if (_currentAttendanceId != null && _punchInTime != null) {
        final totalMinutes = _punchOutTime!.difference(_punchInTime!).inMinutes;
        final model = Biomatricattendancemodel(
          attendanceId: _currentAttendanceId,
          employeeId: 21,
          attendanceDate: _punchInTime,
          inTime: _punchInTime,
          outTime: _punchOutTime,
          status: "Present",
          workType: "provision",
          shiftId: 1,
          latitude: _currentPosition?.latitude,
          longitude: _currentPosition?.longitude,
          totalHours: (totalMinutes / 60).toStringAsFixed(2),
        );

        _workflow
            .updateAttendance(model.attendanceId!, model)
            .then((res) {
              print("✅ Attendance Updated: ${res?.attendanceId}");
            })
            .catchError((err) {
              print("❌ Update error: $err");
            });
      } else {
        print("⚠️ Error: attendanceId, Punch In or Punch Out missing.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biometric Attendance')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Welcome $username',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Icon(
                _isAuthenticated ? Icons.fingerprint_rounded : Icons.lock_open,
                size: 100,
                color: _isAuthenticated ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 20),
              Text(
                'Biometric Authentication',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                _authStatus,
                style: TextStyle(
                  color: _isAuthenticated ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed:
                    _canCheckBiometrics && _availableBiometrics.isNotEmpty
                        ? _authenticate
                        : null,
                icon: const Icon(Icons.fingerprint),
                label: Text(_isPunchedIn ? 'Punch Out' : 'Punch In'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 183, 219, 248),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_address != null)
                Text(
                  'Location: $_address',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              if (_punchInTime != null)
                Text(
                  'Punch In: ${_punchInTime!.toLocal().toString().split('.')[0]}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                  ),
                ),
              if (_punchOutTime != null)
                Text(
                  'Punch Out: ${_punchOutTime!.toLocal().toString().split('.')[0]}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                  ),
                ),
              if (_canCheckBiometrics && _availableBiometrics.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'No biometrics enrolled. Please enroll a fingerprint or Face ID.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
