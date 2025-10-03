import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:payrollapp/Pages/home.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:payrollapp/Models/otpverifymodel.dart';
import 'package:payrollapp/Workflows/otpverifyworkflow.dart';
import 'package:payrollapp/Pages/companynamepopup.dart';

class OtpVerify extends StatefulWidget {
  final String contact;

  const OtpVerify({super.key, required this.contact});

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> with CodeAutoFill {
  String _otpCode = "";
  bool _isLoading = false;
  int _seconds = 10; 

  final Otpverifyworkflow _authWorkflow = Otpverifyworkflow();

  @override
  void initState() {
    super.initState();
    listenForCode();
    _startTimer();
  }

  void _startTimer() {
    _seconds = 50;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (_seconds == 0) return false;
      if (mounted) setState(() => _seconds--);
      return true;
    });
  }

  @override
  void codeUpdated() {
    setState(() {
      _otpCode = code ?? "";
    });
    if (_otpCode.length == 4) _verifyOtp();
  }

  Future<void> _verifyOtp() async {
    if (_otpCode.length != 4) return;

    setState(() => _isLoading = true);

    final model = Otpverifymodel(emailOrPhone: widget.contact, otp: _otpCode);
    final isSuccess = await _authWorkflow.verifyOtp(model);

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isSuccess
            ? 'OTP Verified Successfully'
            : 'OTP Verification Failed'),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );

    if (isSuccess) {
      // Navigate to Home first
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
      Future.delayed(const Duration(milliseconds: 200), () async {
        final createdCompany = await Companynamepopup.show(context);

        if (createdCompany != null) {
          print('Company created: ${createdCompany.companyName}');
        }
      });
    }
  }

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  bool get _isEmail => widget.contact.contains('@');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF8FF),
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Image.asset('lib/assets/resetpassword.png', height: 170),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(2, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Enter code",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _isEmail
                              ? "We’ve sent a verification code to your email\n${widget.contact}"
                              : "We’ve sent an SMS with a code to your phone\n${widget.contact}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 25),
                        PinFieldAutoFill(
                          codeLength: 4,
                          currentCode: _otpCode,
                          onCodeChanged: (code) {
                            if (code != null) {
                              setState(() => _otpCode = code);
                              if (code.length == 4) _verifyOtp();
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: BoxLooseDecoration(
                            bgColorBuilder:
                                FixedColorBuilder(Colors.grey.shade200),
                            strokeColorBuilder:
                                FixedColorBuilder(Colors.blueAccent),
                            radius: const Radius.circular(12),
                            gapSpace: 12,
                            textStyle: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _seconds == 0
                              ? "Send code again"
                              : "Send code again    00:${_seconds.toString().padLeft(2, '0')}",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: (_otpCode.length == 4 && !_isLoading)
                                ? _verifyOtp
                                : null,
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (states) => states.contains(MaterialState.disabled)
                                    ? Colors.blue.shade300
                                    : const Color(0xFF007BFF),
                              ),
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.white),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2)
                                : const Text("Verify",
                                    style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _seconds == 0 ? _startTimer : null,
                          child: Text(
                            _seconds == 0
                                ? "Resend OTP"
                                : "Resend OTP in $_seconds s",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 14,
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
