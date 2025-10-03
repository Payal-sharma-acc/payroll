import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payrollapp/Models/loginnumberotpmodel.dart';
import 'package:payrollapp/Workflows/loginnumberotpworkflow.dart';
import 'package:payrollapp/Pages/home.dart';

class Loginnumberotp extends StatefulWidget {
  final String emailOrPhone;

  const Loginnumberotp({super.key, required this.emailOrPhone});

  @override
  State<Loginnumberotp> createState() => _LoginnumberotpState();
}

class _LoginnumberotpState extends State<Loginnumberotp> {
  final List<TextEditingController> otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  bool _isLoading = false;
  int _secondsRemaining = 20;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _timer?.cancel();
    _secondsRemaining = 20;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _onOtpChanged(int index, String value) {
    if (value.length == 1 && index < 3) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
  }

  Future<void> _verifyOtp() async {
    final otp = otpControllers.map((e) => e.text.trim()).join();

    if (otp.length != 4) {
      _showSnackBar("Please enter the 4-digit OTP");
      return;
    }

    setState(() => _isLoading = true);

    print("Debug EmailOrPhone: '${widget.emailOrPhone}'");
    print("Debug OTP: '$otp'");

    try {
      final success = await Loginnumberotpworkflow().loginWithOtp(
        Loginnumberotpmodel(
          emailOrPhone: widget.emailOrPhone,
          otp: otp,
        ),
      );

      setState(() => _isLoading = false);

      if (success != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Home()),
        );
      } else {
        _showSnackBar("Invalid OTP");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar("Error: ${e.toString()}");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 55,
      height: 60,
      child: TextField(
        controller: otpControllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) => _onOtpChanged(index, value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
         decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFFFFF),
            Color.fromARGB(255, 218, 250, 253),
          ],
          stops: [0.3, 1.0], 
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  Image.asset(
                    "lib/assets/resetpassword.png",
                    height: 180,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Enter code",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Enter the code sent to ${widget.emailOrPhone}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(4, _buildOtpBox),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Send code again   00:${_secondsRemaining.toString().padLeft(2, '0')}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _verifyOtp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1976D2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2)
                                : const Text(
                                    "Verify",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
