import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payrollapp/Models/employeeprofilemodel.dart';
import 'package:payrollapp/Workflows/employeeprofileworkflow.dart';

class Employeeprofile extends StatefulWidget {
  final int employeeId;

  const Employeeprofile({super.key, required this.employeeId});

  @override
  State<Employeeprofile> createState() => _EmployeeprofileState();
}

class _EmployeeprofileState extends State<Employeeprofile> {
  late Future<Employeeprofilemodel> _futureDetails;

  @override
  void initState() {
    super.initState();
    _futureDetails = Employeeprofileworkflow().getPersonalDetails(
      widget.employeeId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Employee Profile")),
      body: FutureBuilder<Employeeprofilemodel>(
        future: _futureDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("❌ Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No data found"));
          }

          final details = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage("lib/assets/userimg.png"),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Employee ID: ${details.employeeId}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const Divider(height: 24),

                    _infoRow(
                      Icons.cake,
                      "Date of Birth",
                      details.dateOfBirth != null &&
                              details.dateOfBirth.isNotEmpty
                          ? DateFormat(
                            'dd MMM yyyy',
                          ).format(DateTime.parse(details.dateOfBirth))
                          : "N/A",
                    ),
                    _infoRow(Icons.person, "Father's Name", details.fatherName),
                    _infoRow(Icons.credit_card, "PAN", details.pan),
                    _infoRow(
                      Icons.email,
                      "Personal Email",
                      details.personalEmailAddress,
                    ),
                    _infoRow(
                      Icons.location_on,
                      "Address",
                      "${details.addressLine1}, ${details.addressLine2}",
                    ),
                    _infoRow(
                      Icons.map,
                      "City/State",
                      "${details.city}, ${details.state}",
                    ),
                    _infoRow(Icons.pin_drop, "Pin Code", details.pinCode),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "$label : $value",
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
