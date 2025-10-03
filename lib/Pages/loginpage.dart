import 'package:flutter/material.dart';
import 'package:payrollapp/Models/loginmodel.dart';
import 'package:payrollapp/Pages/forgotpassword.dart';
import 'package:payrollapp/Pages/home.dart';
import 'package:payrollapp/Pages/loginwithotp.dart';
import 'package:payrollapp/Pages/signup.dart';
import 'package:payrollapp/Pages/salaryconfig.dart'; 
import 'package:payrollapp/Workflows/loginworkflow.dart';
import 'package:payrollapp/utils/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final TextEditingController emailPhoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureText = true;
Future<void> navigateToemployeelogin(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isEmployeeLoggedIn = prefs.getBool("isEmployeeLoggedIn") ?? false;

  if (isEmployeeLoggedIn) {
 
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  } else {
   
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const loginpage()),
    );
  }
}
  void _handleLogin() async {
    final contact = emailPhoneController.text.trim();
    final password = passwordController.text.trim();

    if (contact.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter both email/phone and password."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final loginModel = Loginmodel(
      emailOrPhone: contact,
      password: password,
    );

    final loginWorkflow = LoginWorkflow();
    final loginResponse = await loginWorkflow.login(loginModel);

    setState(() => _isLoading = false);

    if (loginResponse != null) {
      final String token = loginResponse['token'];
      final String refreshToken = loginResponse['refreshToken'];
          final prefs = await SharedPreferences.getInstance();
     await prefs.setBool("isEmployeeLoggedIn", true); 
      await TokenStorage.saveToken(token);
      await TokenStorage.saveRefreshToken(refreshToken);
     

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login successful!"),
          backgroundColor: Colors.green,
        ),
      );

    
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Home(),
      )
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login failed! Please check credentials."),
          backgroundColor: Colors.red,
        ),
      );
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
                  Image.asset('lib/assets/login.png', height: 250),
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
                        onPressed: () =>
                            setState(() => _obscureText = !_obscureText),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const Loginwithotp()),
                        ),
                        child: const Text("Login with OTP",
                            style: TextStyle(color: Colors.blue)),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ForgotPassword()),
                        ),
                        child: const Text("Forgot password?",
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Log in",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text("Or with"),
                      ),
                      Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Image.asset(
                        'lib/assets/googleicon.png',
                        height: 20,
                      ),
                      label: const Text("Google"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const Signup(role: 'SuperAdmin')),
                        ),
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
