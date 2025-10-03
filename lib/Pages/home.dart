import 'package:flutter/material.dart';
import 'package:payrollapp/Pages/addemployee.dart';
import 'package:payrollapp/Pages/department.dart';
import 'package:payrollapp/Pages/designation.dart';
import 'package:payrollapp/Pages/designationget.dart';
import 'package:payrollapp/Pages/employeelist.dart';
import 'package:payrollapp/Pages/loginpage.dart';
import 'package:payrollapp/Pages/payschedule.dart';
import 'package:payrollapp/Pages/permission.dart';
import 'package:payrollapp/Pages/salaryconfig.dart';
import 'package:payrollapp/Pages/worklocation.dart';
import 'package:payrollapp/Pages/worklocationget.dart';
import 'package:payrollapp/Workflows/designationworkflow.dart';
import 'package:payrollapp/Workflows/worklocationgetworkflow.dart';
import 'package:payrollapp/main.dart';
import 'package:payrollapp/utils/token_storage.dart';
import 'package:payrollapp/Workflows/departmentgetworkflow.dart';
import 'package:payrollapp/Pages/departmentget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final String? userName;
  const Home({super.key, this.userName});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _isEmployeePanelVisible = false;
  int _selectedIndex = 0;
  int? orgId;

  final LinearGradient _boxGradient = const LinearGradient(
    colors: [Color(0xFFFFFFFF), Color.fromARGB(255, 218, 250, 253)],
    stops: [0.3, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _loadOrgId();
  }

  
  Future<void> _loadOrgId() async {
    final storedOrgId = await TokenStorage.getAdminUserId();
    setState(() {
      orgId = storedOrgId;
    });
  }

  void _toggleEmployeePanel() {
    setState(() {
      _isEmployeePanelVisible = !_isEmployeePanelVisible;
      _isEmployeePanelVisible ? _controller.forward() : _controller.reverse();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 4) {
      _showSettingsPanel(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildEmployeePanel() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          gradient: _boxGradient,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
          ),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Employees",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Onboard employees and manage everything in one place",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildImageEmployeeCard(
              "Add Employee",
              'lib/assets/addemployee.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Addemployee()),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildImageEmployeeCard(
              "Employee List",
              'lib/assets/employeelist2.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EmployeeListScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageEmployeeCard(
    String title,
    String imagePath, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 9,
        shadowColor: Colors.black38,
        child: Container(
          width: 180,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            gradient: _boxGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(String imagePath, String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 130,
        decoration: BoxDecoration(
          gradient: _boxGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              elevation: 6,
              shadowColor: Colors.black38,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('lib/assets/img1.png', height: 170),
                  const SizedBox(height: 20),
                  const Text(
                    "Efficient payroll Management made easy",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildMenuCard(
                                'lib/assets/dashboard.png',
                                "Dashboard",
                              ),
                              _buildMenuCard(
                                'lib/assets/employee.png',
                                "Employees",
                                onTap: _toggleEmployeePanel,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildMenuCard(
                                'lib/assets/paysedule.png',
                                "Pay Schedule",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const PaySchedule(),
                                    ),
                                  );
                                },
                              ),
                              _buildMenuCard(
                                'lib/assets/report.png',
                                "Reports",
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: _buildMenuCard(
                              'lib/assets/attendance.png',
                              "Attendance",
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isEmployeePanelVisible)
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleEmployeePanel,
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
            ),
          Align(alignment: Alignment.centerRight, child: _buildEmployeePanel()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('lib/assets/home.png', height: 24, width: 24),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Image.asset('lib/assets/tasks.png', height: 24, width: 24),
            label: "Tasks",
          ),
          BottomNavigationBarItem(
            icon: Image.asset('lib/assets/plus.png', height: 28, width: 28),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'lib/assets/approvals.png',
              height: 24,
              width: 24,
            ),
            label: "Approvals",
          ),
          BottomNavigationBarItem(
            icon: Image.asset('lib/assets/more.png', height: 24, width: 24),
            label: "More",
          ),
        ],
      ),
    );
  }
  void _showSettingsPanel(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Settings",
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 650),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

        return SlideTransition(
          position: offsetAnimation,
          child: Align(
            alignment: Alignment.topRight,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 260,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  gradient: _boxGradient,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                  ),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _settingCard(
                        context,
                        'lib/assets/permission.png',
                        'Permission',
                        const Permission(),
                      ),
                      _settingCard(
                        context,
                        'lib/assets/location.png',
                        'Work Location',
                        const Worklocation(),
                      ),
                      _settingCard(
                        context,
                        'lib/assets/designation.png',
                        'Designation',
                        const Designation(),
                      ),
                      _settingCard(
                        context,
                        'lib/assets/department.png',
                        'Department',
                        const Department(),
                      ),
                      _settingCard(context, 'lib/assets/shift.png', 'Shifts'),
                      _settingCard(
                        context,
                        'lib/assets/payschedule1.png',
                        'Pay Schedule',
                        const PaySchedule(),
                      ),
                      _settingCard(
                        context,
                        'lib/assets/salaryconfiguration.png',
                        'Salary Configuration',
                        SalaryConfig(orgId: orgId ?? 0),
                      ),
                      _settingCard(context, 'lib/assets/power.png', 'Logout'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
  Widget _settingCard(
    BuildContext context,
    String iconPath,
    String title, [
    Widget? page,
  ]) {
    return GestureDetector(
      onTap: () async {
        final homeContext = context;
        Navigator.pop(homeContext);

        await Future.delayed(const Duration(milliseconds: 100));

if (title == "Logout") {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text("Logout"),
      content: const Text("Are you sure you want to logout?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text("Yes"),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  if (navigatorKey.currentState != null) {
    navigatorKey.currentState!.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const loginpage()),
      (route) => false,
    );
  } else {
    print("⚠️ navigatorKey.currentState is null!");
  }
}
        else if (title == "Department") {
          final departments = await DepartmentgetWorkflow.getDepartments();
          if (!context.mounted) return;

          if (departments.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Departmentget()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Department()),
            );
          }
        }
        else if (title == "Designation") {
          final designations = await DesignationWorkflow.getAllDesignations();
          if (!context.mounted) return;

          if (designations.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Designationget()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Designation()),
            );
          }
        }
        else if (title == "Work Location") {
          final workLocations =
              await Worklocationgetworkflow.getWorkLocations();
          if (!context.mounted) return;

          if (workLocations.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Worklocationget()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Worklocation()),
            );
          }
        }
      
        else if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: _boxGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              offset: const Offset(-3, -3),
              blurRadius: 6,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(3, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Card(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  iconPath,
                  height: 30,
                  width: 30,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
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
