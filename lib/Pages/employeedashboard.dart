import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:payrollapp/Models/biometricattendancemodel.dart';
import 'package:payrollapp/Models/employeeupcomingholidaysmodel.dart';
import 'package:payrollapp/Pages/employeeadvancedpayment.dart';
import 'package:payrollapp/Pages/employeeexpense.dart';
import 'package:payrollapp/Pages/employeeleave.dart';
import 'package:payrollapp/Pages/employeelogin.dart';
import 'package:payrollapp/Pages/employeeoutduty.dart';
import 'package:payrollapp/Pages/employeeprofile.dart';
import 'package:payrollapp/Pages/employeetask.dart';
import 'package:payrollapp/Pages/employeeuploadocument.dart';
import 'package:payrollapp/Workflows/biomatricattendanceworkflow.dart';
import 'package:payrollapp/Workflows/employeeattendancecalenderworkflow.dart';
import 'package:payrollapp/Workflows/employeeupcomingholidaysworkflow.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payrollapp/Pages/EmployeeSalarySlipPage.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum AttendanceStatus { present, absent, halfDay, leave, none }

class Employeedashboard extends StatefulWidget {
  final int? employeeId;

  const Employeedashboard({super.key, this.employeeId});

  @override
  State<Employeedashboard> createState() => _EmployeedashboardState();
}

class _EmployeedashboardState extends State<Employeedashboard>
    with SingleTickerProviderStateMixin {
  int? selectedEmployeeId;
  List<EmployeeHolidayModel> holidays = [];
  Map<int, Biomatricattendancemodel> dynamicAttendance = {};
  bool isLoadingAttendance = false;
  Map<int, AttendanceStatus> attendanceData = {};
  Map<int, String> punchTime = {};

  String? fullName;
  bool isLoadingHolidays = false;

  int _holidayNotificationCount = 0;
  bool _isMenuOpen = false;
  late AnimationController _animationController;

  final LocalAuthentication auth = LocalAuthentication();
  DateTime? lastPunchInTime;
  bool isPunchInDisabled = false;
  bool isPunchOutDisabled = false;
  DateTime? lastPunchOutTime;

  Future<void> _loadPunchInTime() async {
    final prefs = await SharedPreferences.getInstance();
    final millis = prefs.getInt("lastPunchInTime");
    if (millis != null) {
      lastPunchInTime = DateTime.fromMillisecondsSinceEpoch(millis);
      _checkPunchInAvailability();
    }
  }

  Future<void> _loadPunchOutTime() async {
    final prefs = await SharedPreferences.getInstance();
    final millis = prefs.getInt("lastPunchOutTime");
    if (millis != null) {
      lastPunchOutTime = DateTime.fromMillisecondsSinceEpoch(millis);
      _checkPunchOutAvailability();
    }
  }

  void _checkPunchOutAvailability() {
    if (lastPunchOutTime != null) {
      final diff = DateTime.now().difference(lastPunchOutTime!);
      if (diff.inHours < 8) {
        setState(() => isPunchOutDisabled = true);

        Future.delayed(Duration(hours: 8) - diff, () {
          setState(() => isPunchOutDisabled = false);
        });
      } else {
        setState(() => isPunchOutDisabled = false);
      }
    }
  }

  void _checkPunchInAvailability() {
    if (lastPunchInTime != null) {
      final diff = DateTime.now().difference(lastPunchInTime!);
      if (diff.inHours < 8) {
        setState(() => isPunchInDisabled = true);

        Future.delayed(Duration(hours: 8) - diff, () {
          setState(() => isPunchInDisabled = false);
        });
      } else {
        setState(() => isPunchInDisabled = false);
      }
    }
  }

  final List<Map<String, dynamic>> arcMenuItems = [
    {
      "label": "Leave Balance",
      "image": "lib/assets/leavebalance.png",
      "page": (BuildContext context) => const EmployeeLeave(),
    },
    {
      "label": "Advanced Payment",
      "image": "lib/assets/advancedpayment.png",
      "page":
          (BuildContext context) => const EmployeeAdvancePaymentRequestPage(),
    },
    {
      "label": "On Duty",
      "image": "lib/assets/outduity.png",
      "page": (BuildContext context) => const EmployeeOutDuty(),
    },
    {
      "label": "Expense",
      "image": "lib/assets/expense.png",
      "page": (BuildContext context) => EmployeeExpense(),
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadEmployeeId();
    _loadPunchInTime();
    _fetchHolidays();
    _fetchAttendance();
    _loadUserName();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<void> _fetchAttendance() async {
    setState(() => isLoadingAttendance = true);
    try {
      final data = await Employeeattendancecalenderworkflow.getAllAttendance();

      final Map<int, AttendanceStatus> tempAttendance = {};
      final Map<int, String> tempPunchTime = {};

      final now = DateTime.now();
      final month = now.month;
      final year = now.year;

      for (var record in data) {
        final date = record.attendanceDate;
        if (date.month == month && date.year == year) {
          final day = date.day;

          AttendanceStatus status;
          if (record.leaveType != null) {
            status = AttendanceStatus.leave;
          } else if (record.halfDay == true) {
            status = AttendanceStatus.halfDay;
          } else if (record.inTime != null) {
            status = AttendanceStatus.present;
          } else {
            status = AttendanceStatus.absent;
          }

          tempAttendance[day] = status;
          String punch = "";
          if (record.inTime != null) {
            punch += "In: ${DateFormat.Hm().format(record.inTime!)}";
          }
          if (record.outTime != null) {
            punch += "\nOut: ${DateFormat.Hm().format(record.outTime!)}";
          }
          if (punch.isNotEmpty) tempPunchTime[day] = punch;
        }
      }

      setState(() {
        attendanceData = tempAttendance;
        punchTime = tempPunchTime;
        isLoadingAttendance = false;
      });
    } catch (e) {
      setState(() => isLoadingAttendance = false);
      debugPrint("Error fetching attendance: $e");
    }
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString("fullName") ?? "Employee";
    });
    print("🔹 Loaded fullName: $fullName");
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadEmployeeId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedEmployeeId = prefs.getInt("employeeId") ?? widget.employeeId;
    });
  }

  Future<void> _fetchHolidays() async {
    setState(() => isLoadingHolidays = true);
    try {
      final data = await EmployeeHolidayWorkflow().getAllHolidays();
      final now = DateTime.now();
      final currentMonthHolidays =
          data
              .where(
                (h) =>
                    h.holidayDate.month == now.month &&
                    h.holidayDate.year == now.year,
              )
              .toList();

      setState(() {
        holidays = currentMonthHolidays;
        isLoadingHolidays = false;
        _holidayNotificationCount = holidays.length;
      });
    } catch (e) {
      setState(() => isLoadingHolidays = false);
      debugPrint("Error fetching holidays: $e");
    }
  }

  Future<void> _refreshDashboard() async {
    await _fetchHolidays();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Widget _buildArcMenu(BuildContext context) {
    final double radius = 120;
    final double angleStep = 180 / (arcMenuItems.length - 1);
    final double startAngle = 180;

    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !_isMenuOpen,
        child: AnimatedOpacity(
          opacity: _isMenuOpen ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              GestureDetector(
                onTap: _toggleMenu,
                child: Container(color: Colors.black54),
              ),
              ...List.generate(arcMenuItems.length, (index) {
                final double angle = startAngle + (index * angleStep);
                final double rad = angle * (pi / 180);
                final double dx = radius * cos(rad);
                final double dy = radius * sin(rad);
                final item = arcMenuItems[index];
                return Transform.translate(
                  offset: Offset(dx, dy),
                  child: GestureDetector(
                    onTap: () {
                      if (item["page"] != null) {
                        final pageBuilder =
                            item["page"] as Widget Function(BuildContext);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => pageBuilder(context),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${item["label"]} clicked")),
                        );
                      }
                      _toggleMenu();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.white, Colors.lightBlueAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Image.asset(
                              item["image"] as String,
                              width: 36,
                              height: 36,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item["label"] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePunch(String type) async {
    final now = DateTime.now();
    final day = now.day;

    if (type == "IN" && isPunchInDisabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Punch In is disabled for 8 hours")),
      );
      return;
    }

    if (type == "OUT" && isPunchOutDisabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Punch Out is disabled for 8 hours")),
      );
      return;
    }
    lastPunchOutTime = now;
    isPunchOutDisabled = true;
    SharedPreferences.getInstance().then(
      (prefs) => prefs.setInt("lastPunchOutTime", now.millisecondsSinceEpoch),
    );
    Future.delayed(const Duration(hours: 8), () {
      setState(() => isPunchOutDisabled = false);
    });

    try {
      final bool result = await auth.authenticate(
        localizedReason: 'Please authenticate to $type',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (result) {
        setState(() {
          if (type == "IN") {
            punchTime[day] =
                "In: ${TimeOfDay.fromDateTime(now).format(context)}";
            attendanceData[day] = AttendanceStatus.present;

            lastPunchInTime = now;
            isPunchInDisabled = true;

            SharedPreferences.getInstance().then(
              (prefs) =>
                  prefs.setInt("lastPunchInTime", now.millisecondsSinceEpoch),
            );

            Future.delayed(const Duration(hours: 8), () {
              setState(() => isPunchInDisabled = false);
            });

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Punch In recorded")));
          } else {
            if (!(punchTime[day]?.contains("In:") ?? false)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please Punch In first")),
              );
              return;
            }

            if (punchTime[day]?.contains("Out:") ?? false) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Punch Out  done")));
              return;
            }

            final existing = punchTime[day] ?? "";
            punchTime[day] =
                "$existing\nOut: ${TimeOfDay.fromDateTime(now).format(context)}";

            lastPunchOutTime = now;
            isPunchOutDisabled = true;

            SharedPreferences.getInstance().then(
              (prefs) =>
                  prefs.setInt("lastPunchOutTime", now.millisecondsSinceEpoch),
            );

            Future.delayed(const Duration(hours: 8), () {
              setState(() => isPunchOutDisabled = false);
            });

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Punch Out recorded")));
          }
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to authenticate")));
      }
    } catch (e) {
      debugPrint("Punch Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Widget _buildAttendanceSummary() {
    final summary = <String, Map<String, dynamic>>{
      "Present": {"count": 0, "color": Colors.green},
      "Absent": {"count": 0, "color": Colors.red},
      "Half Day": {"count": 0, "color": Colors.orange},
      "Leave": {"count": 0, "color": Colors.blue},
    };

    attendanceData.forEach((day, status) {
      switch (status) {
        case AttendanceStatus.present:
          summary["Present"]!["count"]++;
          break;
        case AttendanceStatus.absent:
          summary["Absent"]!["count"]++;
          break;
        case AttendanceStatus.halfDay:
          summary["Half Day"]!["count"]++;
          break;
        case AttendanceStatus.leave:
          summary["Leave"]!["count"]++;
          break;
        default:
          break;
      }
    });

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            summary.entries.map((entry) {
              return Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: entry.value["color"],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${entry.key}\n${entry.value["count"]}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final List<Map<String, dynamic>> dummyData = [
      {
        "title": "Salary Slip",
        "image": "lib/assets/salaryslip.png",
        "page": EmployeeSalarySlipPage(
          employeeId: selectedEmployeeId ?? 0,
          year: now.year,
          month: now.month,
        ),
      },
      {
        "title": "Upload Document",
        "image": "lib/assets/myattendance.png",
        "page": EmployeeUploadDocumentPage(),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Employeetask()),
            );
          } else if (index == 2) {
            _toggleMenu();
          }
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tasks"),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40),
            label: "",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),

      body: Stack(
        children: [
          Container(color: Colors.white),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: RefreshIndicator(
                onRefresh: _refreshDashboard,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hello,${fullName ?? ''} 👋",
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 4),
                              Text(
                                DateFormat(
                                  'EEEE, dd MMM yyyy',
                                ).format(DateTime.now()),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              Stack(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.notifications,
                                      size: 28,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      _showHolidaySheet(context);
                                    },
                                  ),
                                  if (_holidayNotificationCount > 0)
                                    Positioned(
                                      right: 6,
                                      top: 6,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          _holidayNotificationCount.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              PopupMenuButton<String>(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                offset: const Offset(0, 36),

                                onSelected: (value) async {
                                  final prefs =
                                      await SharedPreferences.getInstance();

                                  if (value == "Profile") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => Employeeprofile(
                                              employeeId:
                                                  selectedEmployeeId ?? 0,
                                            ),
                                      ),
                                    );
                                  } else if (value == "Logout") {
                                    bool? confirm = await showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: const Text("Logout"),
                                            content: const Text(
                                              "Are you sure you want to logout?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      false,
                                                    ),
                                                child: const Text("No"),
                                              ),
                                              TextButton(
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      true,
                                                    ),
                                                child: const Text("Yes"),
                                              ),
                                            ],
                                          ),
                                    );

                                    if (confirm == true) {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.clear();

                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => Employeelogin(),
                                        ),
                                        (route) => false,
                                      );
                                    }
                                  }
                                },
                                itemBuilder:
                                    (BuildContext context) => [
                                      const PopupMenuItem(
                                        value: "Profile",
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.person,
                                              color: Colors.blue,
                                            ),
                                            SizedBox(width: 8),
                                            Text("Profile"),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: "Logout",
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.logout,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 8),
                                            Text("Logout"),
                                          ],
                                        ),
                                      ),
                                    ],
                                child: const CircleAvatar(
                                  radius: 19,
                                  backgroundImage: AssetImage(
                                    "lib/assets/userimg.png",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          if (isLoadingAttendance)
                            const Center(child: CircularProgressIndicator())
                          else
                            AttendanceCalendar(
                              year: now.year,
                              month: now.month,
                              attendance: attendanceData,
                              punchTime: punchTime,
                            ),
                          _buildAttendanceSummary(),
                        ],
                      ),

                      const SizedBox(height: 20),

                      GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        physics: const NeverScrollableScrollPhysics(),
                        children:
                            dummyData.map((item) {
                              return _menuCard(
                                item["title"]!,
                                item["image"]!,
                                item["page"],
                                context,
                              );
                            }).toList(),
                      ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => _handlePunch("IN"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: const Size(140, 40),
                            ),
                            child: const Text(
                              "Punch In",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed:
                                isPunchOutDisabled
                                    ? null
                                    : () => _handlePunch("OUT"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: const Size(140, 40),
                            ),
                            child: const Text(
                              "Punch Out",
                              style: TextStyle(color: Colors.white),
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
          if (_isMenuOpen)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(color: Colors.black.withOpacity(0.2)),
              ),
            ),
          if (_isMenuOpen) _buildArcMenu(context),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Employeetask()),
          );
        } else if (index == 2) {
          _toggleMenu();
        }
      },

      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tasks"),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, size: 40),
          label: "",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Setting"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }

  static Widget _menuCard(
    String title,
    String imagePath, [
    Widget? page,
    BuildContext? context,
  ]) {
    return InkWell(
      onTap: () {
        if (page != null && context != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _holidayCard(String title, String formattedDate, String day) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
        image: const DecorationImage(
          image: AssetImage("lib/assets/holidayback.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                day,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
          Text(
            formattedDate,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _showHolidaySheet(BuildContext context) {
    final now = DateTime.now();
    final currentMonthHolidays =
        holidays
            .where(
              (h) =>
                  h.holidayDate.month == now.month &&
                  h.holidayDate.year == now.year,
            )
            .toList();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        if (currentMonthHolidays.isEmpty) {
          return SizedBox(
            height: 150,
            child: Center(
              child: Text(
                "No upcoming holidays this month",
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: currentMonthHolidays.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final holiday = currentMonthHolidays[index];
              final formattedDate = DateFormat(
                'dd MMM yyyy',
              ).format(holiday.holidayDate);
              final dayOfWeek = DateFormat('EEEE').format(holiday.holidayDate);
              return _holidayCard(
                holiday.holidayName,
                formattedDate,
                dayOfWeek,
              );
            },
          ),
        );
      },
    );

    setState(() {
      _holidayNotificationCount = 0;
    });
  }
}

class AttendanceCalendar extends StatefulWidget {
  final int year;
  final int month;
  final Map<int, AttendanceStatus> attendance;
  final Map<int, String> punchTime;

  const AttendanceCalendar({
    super.key,
    required this.year,
    required this.month,
    required this.attendance,
    required this.punchTime,
  });

  @override
  State<AttendanceCalendar> createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  late Map<int, AttendanceStatus> attendanceData;
  late Map<int, String> punchData;

  @override
  void initState() {
    super.initState();
    attendanceData = Map<int, AttendanceStatus>.from(widget.attendance);
    punchData = Map<int, String>.from(widget.punchTime);
  }

  Color _getColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Colors.green;
      case AttendanceStatus.absent:
        return Colors.red;
      case AttendanceStatus.halfDay:
        return Colors.orange;
      case AttendanceStatus.leave:
        return Colors.blue;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(widget.year, widget.month);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: daysInMonth,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        final day = index + 1;
        final status = attendanceData[day] ?? AttendanceStatus.none;
        final punch = punchData[day] ?? "";

        return InkWell(
          onTap: () {
            if (punch.isNotEmpty) {
              showDialog(
                context: context,
                builder: (context) {
                  List<String> times = punch.split('\n');
                  String inTime = times.isNotEmpty ? times[0] : "N/A";
                  String outTime = times.length > 1 ? times[1] : "N/A";

                  return AlertDialog(
                    title: Text("Attendance - Day $day"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(inTime, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        Text(outTime, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close"),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Tooltip(
            message: punch.isNotEmpty ? punch : "No data",
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _getColor(status),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                day.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
