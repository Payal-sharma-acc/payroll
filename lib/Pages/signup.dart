import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:payrollapp/Models/signupmodel.dart';
import 'package:payrollapp/Pages/loginpage.dart';
import 'package:payrollapp/Pages/otpverify.dart';
import 'package:payrollapp/Workflows/signupworkflow.dart';

class Signup extends StatefulWidget {
  final String role;
  const Signup({super.key, required this.role});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordHidden = true;
  String _passwordError = '';
  bool _isLoading = false;

  void navigateToOtpScreen(String contact) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => OtpVerify(contact: contact)),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Signup successful'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> handleSignup() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      showErrorSnackBar('No internet connection');
      return;
    }

    final name = nameController.text.trim();
    final emailOrPhone = emailPhoneController.text.trim();
    final password = passwordController.text.trim();

    final passwordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');

    setState(() {
      _passwordError = '';
    });

    if (name.isEmpty || emailOrPhone.isEmpty || password.isEmpty) {
      showErrorSnackBar('Please enter all fields');
      return;
    }

    if (!passwordRegex.hasMatch(password)) {
      setState(() {
        _passwordError =
            'Password must be at least 8 characters, include uppercase, lowercase, number, and special character.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await Signupworkflow().signup(SignupModel(
      name: name,
      emailOrPhone: emailOrPhone,
      password: password,
      role: widget.role,
    ));

    setState(() {
      _isLoading = false;
    });

    if (result == 'success') {
      navigateToOtpScreen(emailOrPhone);
    } else {
      showErrorSnackBar(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildSignupForm(),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return Container(
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Image.asset('lib/assets/signupimage.png', height: 180),
                const SizedBox(height: 20),
                const Text(
                  'Create account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                TextField(
                  controller: nameController,
                  decoration: _inputDecoration('Name'),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: emailPhoneController,
                  decoration:
                      _inputDecoration('Email address', hint: 'Your email'),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: passwordController,
                  obscureText: _isPasswordHidden,
                  decoration: _inputDecoration('Password').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordHidden
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                    ),
                  ),
                ),

                if (_passwordError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _passwordError,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : handleSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A73E8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                const Text('Or Register With'),
                const SizedBox(height: 12),

                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Image.asset('lib/assets/googleicon.png', height: 24),
                    label: const Text('Google',
                        style: TextStyle(color: Colors.black)),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an Account? "),
                    GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (_) => const loginpage()),
                        // );
                      },
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
