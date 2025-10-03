import 'package:flutter/material.dart';
import 'package:payrollapp/Models/forgotpasswordmodel.dart';
import 'package:payrollapp/Pages/forgototp.dart';
import 'package:payrollapp/Workflows/forgotpasswordworkflow.dart';
import 'package:payrollapp/Pages/resetpassword.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPassword> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _isPhoneInput = false;

  void _onInputChanged(String value) {
    final isPhone = RegExp(r'^[0-9]{10}$').hasMatch(value.trim());
    setState(() {
      _isPhoneInput = isPhone;
    });
  }

  Future<void> _submit() async {
    final input = _controller.text.trim();

    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        
        SnackBar(
          content: Text(_isPhoneInput
              ? "Phone number is required"
              : "Email address is required"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final model = ForgotPasswordModel(emailOrPhone: input);
    final success =
        await ForgotPasswordWorkflow().sendForgotPasswordRequest(model);

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP sent successfully"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ForgotOtp(emailOrPhone: input),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to send OTP"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
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
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Center(
                child: Image.asset(
                  'lib/assets/forgotpassword.png',
                  height: 250,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Forgot password?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _isPhoneInput
                    ? "Please enter the phone number associated with your account."
                    : "Please enter the email address associated with your account.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _controller,
                onChanged: _onInputChanged,
                decoration: InputDecoration(
                  hintText: _isPhoneInput
                      ? 'Enter your phone number'
                      : 'Enter your email address',
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                keyboardType: _isPhoneInput
                    ? TextInputType.phone
                    : TextInputType.emailAddress,
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Send code",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Remember password? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Log in",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}