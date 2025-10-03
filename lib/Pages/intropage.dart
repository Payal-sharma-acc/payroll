import 'package:flutter/material.dart';
import 'package:payrollapp/Pages/dashboard.dart';

class intropage extends StatelessWidget {
  const intropage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Image.asset('lib/assets/DigiPay.png', fit: BoxFit.contain),
            ),
            Column(
              children: [
                const Text.rich(
                  TextSpan(
                    text: " ",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: "Digi",
                        style: TextStyle(color: Colors.orange),
                      ),
                      TextSpan(
                        text: "Pay",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 500),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        " Say goodbye to rigid, one-size-fits-all software. DigiCortex empowers you to build powerful, enterprise-grade ERP and payroll systems—without writing a single line of code. It’s ERP reimagined: faster to deploy, easier to manage, and built entirely on your terms.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
