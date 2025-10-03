import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:payrollapp/Pages/employeelogin.dart';
import 'package:payrollapp/Pages/employeedashboard.dart';
import 'package:payrollapp/Pages/home.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:payrollapp/Pages/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<String> imagePaths = [
    'lib/assets/pic1.png',
    'lib/assets/pic2.png',
    'lib/assets/pic3.png',
    'lib/assets/pic4.png',
  ];

  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userType = prefs.getString('userType');

    if (userType != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (userType == "admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Home()),
          );
        } else if (userType == "employee") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Employeedashboard()), 
          );
        }
      });
    }
  }
  void navigateToLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', "admin");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const loginpage()),
    );
  }
  void navigateToemployeelogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userType', "employee");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Employeelogin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 300,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    autoPlayAnimationDuration: const Duration(milliseconds: 600),
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    onPageChanged: (index, reason) {
                      setState(() {
                        activeIndex = index;
                      });
                    },
                  ),
                  items: imagePaths.map((path) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.asset(
                              path,
                              width: double.infinity,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 5),
                AnimatedSmoothIndicator(
                  activeIndex: activeIndex,
                  count: imagePaths.length,
                  effect: const WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 6,
                    dotColor: Colors.grey,
                    activeDotColor: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            const Text(
              "Explore the app",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                "Effortless salary management, from payslips to compliance — all in one place.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => navigateToLogin(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    child: const Text(
                      "Login as Admin",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => navigateToemployeelogin(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    child: const Text(
                      "Login as Employee",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
