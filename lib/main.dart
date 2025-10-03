import 'package:flutter/material.dart';
import 'package:payrollapp/Pages/addemployee.dart';
import 'package:payrollapp/Pages/attendanceemployee.dart';
import 'package:payrollapp/Pages/companynamepopup.dart';
import 'package:payrollapp/Pages/departmentget.dart';
import 'package:payrollapp/Pages/designation.dart';
import 'package:payrollapp/Pages/designationform.dart';
import 'package:payrollapp/Pages/designationget.dart';
import 'package:payrollapp/Pages/employeedashboard.dart';
import 'package:payrollapp/Pages/employeelogin.dart';
import 'package:payrollapp/Pages/home.dart';
import 'package:payrollapp/Pages/intropage.dart';
import 'package:payrollapp/Pages/resetpassword.dart';
import 'package:payrollapp/Pages/salarydetail.dart';
import 'package:payrollapp/Pages/worklocation.dart';
import 'package:payrollapp/Pages/worklocationget.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: intropage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Text('Payroll App'),
    );
  }
}
