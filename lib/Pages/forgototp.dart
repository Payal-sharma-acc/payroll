import 'dart:async';
import 'package:flutter/material.dart';
import 'package:payrollapp/Pages/resetpassword.dart';
import 'package:payrollapp/Workflows/forgototpworkflow.dart';
import 'package:payrollapp/utils/token_storage.dart';

class ForgotOtp extends StatefulWidget {
  final String emailOrPhone;

  const ForgotOtp({super.key, required this.emailOrPhone});

  @override
  State<ForgotOtp> createState() => _ForgotOtpState();
}

class _ForgotOtpState extends State<ForgotOtp> {
  final _otpControllers = List.generate(4, (_) => TextEditingController());
  bool isLoading = false;
  String message = '';
  int secondsRemaining = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown(); 
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() {
      secondsRemaining = 52;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  void _verifyOtp() async {
    final otp = _otpControllers.map((e) => e.text).join();
    if (otp.length < 4) {
      setState(() => message = "Please enter all 4 digits.");
      return;
    }

    setState(() {
      isLoading = true;
      message = '';
    });

    final result = await ForgotOtpWorkflow.verifyResetOtp(
      emailOrPhone: widget.emailOrPhone,
      otp: otp,
    );

    setState(() {
      isLoading = false;
    });

    if (result != null && result.success && result.resetToken.isNotEmpty) {
      await TokenStorage.saveResetToken(result.resetToken);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPassword(
            emailOrPhone: widget.emailOrPhone,
            resetToken: result.resetToken,
          ),
        ),
      );
    } else {
      setState(() {
        message = result?.message ?? 'Verification failed';
        if (result?.message?.contains('30 seconds') == true) {
          _startCountdown();
        }
      });
    }
  }

  Widget _buildOtpBox(int index) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: TextField(
          controller: _otpControllers[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(
            counterText: '',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {});
            if (value.isNotEmpty && index < 3) {
              FocusScope.of(context).nextFocus();
            } else if (value.isEmpty && index > 0) {
              FocusScope.of(context).previousFocus();
            }
          },
        ),
      ),
    );
  }

  bool _isEmail(String input) {
    return input.contains('@');
  }

  bool _isOtpComplete() {
    return _otpControllers.every((controller) => controller.text.isNotEmpty);
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFEAF6FE),
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
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 40),
                Image.asset('lib/assets/resetpassword.png', height: 180),
                const SizedBox(height: 20),
                const Text(
                  "Enter OTP",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  _isEmail(widget.emailOrPhone)
                      ? "We’ve sent a code to your email:\n${widget.emailOrPhone}"
                      : "We’ve sent an SMS to your phone:\n${widget.emailOrPhone}",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Row(children: List.generate(4, _buildOtpBox)),
                const SizedBox(height: 20),
                Text(
                  "Send code again in 00:${secondsRemaining.toString().padLeft(2, '0')}",
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (isLoading || !_isOtpComplete())
                      ? null
                      : _verifyOtp, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Verify",
                          style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 10),
                if (message.isNotEmpty)
                  Text(
                    message,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
