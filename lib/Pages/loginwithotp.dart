import 'package:flutter/material.dart';
import 'package:payrollapp/Models/loginwithotpmodel.dart';
import 'package:payrollapp/Workflows/loginwithotpworkflow.dart';
import 'package:payrollapp/Pages/loginnumberotp.dart';

class Loginwithotp extends StatefulWidget {
  const Loginwithotp({super.key});

  @override
  State<Loginwithotp> createState() => _LoginwithotpState();
}

class _LoginwithotpState extends State<Loginwithotp> {
  final TextEditingController _inputController = TextEditingController();
  bool _isLoading = false;
  bool _isUsingPhone = false;

  final RegExp _emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  final RegExp _phoneRegex = RegExp(r"^\d{10}$");

  bool _isValidInput(String input) {
    return _isUsingPhone
        ? _phoneRegex.hasMatch(input)
        : _emailRegex.hasMatch(input);
  }

  void _showSnackBar(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: success ? Colors.green : Colors.red,
    ));
  }

  Future<void> _sendOtp() async {
    final input = _inputController.text.trim();

    if (!_isValidInput(input)) {
      _showSnackBar(_isUsingPhone
          ? "Please enter a valid 10-digit phone number."
          : "Please enter a valid email address.");
      return;
    }

    setState(() => _isLoading = true);

    final model = Loginwithotpmodel(emailOrPhone: input);
    final workflow = loginwithotpworkflow();
    final result = await workflow.sendOtp(model);

    setState(() => _isLoading = false);

    if (result != null) {
      print("📌 OTP Sent to: $input");

      _showSnackBar("OTP sent to $input", success: true);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Loginnumberotp(emailOrPhone: input),
        ),
      );
    } else {
      _showSnackBar("Failed to send OTP");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  _isUsingPhone
                      ? 'lib/assets/loginwithotp.png'
                      : 'lib/assets/loginwithotpmail.png',
                  height: 250,
                ),
                const SizedBox(height: 30),
                const Text(
                  "Log in",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _isUsingPhone
                      ? "Please confirm your phone number."
                      : "Please confirm your email.",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 30),

              
                TextField(
                  controller: _inputController,
                  keyboardType: _isUsingPhone
                      ? TextInputType.phone
                      : TextInputType.emailAddress,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText:
                        _isUsingPhone ? "Enter Phone Number" : "Enter Email",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

        
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Continue",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isUsingPhone = !_isUsingPhone;
                      _inputController.clear();
                    });
                  },
                  child: Text(
                    _isUsingPhone
                        ? "Use Email instead"
                        : "Use Phone number instead",
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
