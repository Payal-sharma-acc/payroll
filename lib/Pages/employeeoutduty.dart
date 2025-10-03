import 'package:flutter/material.dart';
import 'package:payrollapp/Models/employeeonduitystatusmastermodel.dart';
import 'package:payrollapp/Models/employeeoutduitymodel.dart';
import 'package:payrollapp/Models/employeepostonduitymodel.dart';
import 'package:payrollapp/Workflows/employeeonduitystatusmasterworkflow.dart';
import 'package:payrollapp/Workflows/employeeoutduityworkflow.dart';
import 'package:intl/intl.dart';
import 'package:payrollapp/Workflows/employeepostonduityworkflow.dart';
import 'package:payrollapp/utils/token_storage.dart';

class EmployeeOutDuty extends StatefulWidget {
  const EmployeeOutDuty({Key? key}) : super(key: key);

  @override
  State<EmployeeOutDuty> createState() => _EmployeeOutDutyState();
}

class _EmployeeOutDutyState extends State<EmployeeOutDuty> {
  final Employeeoutduityworkflow _workflow = Employeeoutduityworkflow();
  List<Employeeoutduitymodel> odList = [];
  List<StatusMasterModel> statusList = [];
  StatusMasterModel? selectedStatus;
  bool isStatusLoading = true;
  int? employeeId;

  bool isLoading = true;

  // Form controllers
  final TextEditingController inDateController = TextEditingController();
  final TextEditingController outDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  String statusValue = 'Pending';
  final Map<String, int> statusMap = {
    "Pending": 1,
    "Approved": 5,
    "Rejected": 9,
  };

  @override
  void initState() {
    super.initState();
    fetchOnDuty();
    fetchStatuses();
  }

  Future<void> fetchStatuses() async {
    try {
      final data = await StatusMasterWorkflow.getAllStatuses();
      setState(() {
        statusList = data;
        if (statusList.isNotEmpty) {
          selectedStatus = statusList.firstWhere(
            (s) => s.statusName == "Pending",
            orElse: () => statusList.first,
          );
        }
        isStatusLoading = false;
      });
    } catch (e) {
      setState(() => isStatusLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed to fetch statuses: $e")));
    }
  }

  Future<void> fetchOnDuty() async {
    setState(() => isLoading = true);
    try {
      final empId = await TokenStorage.getEmployeeId();
      final allData = await _workflow.getAllOnDuty();
      final filteredOutDuty =
          allData.where((e) => e.appliedByInt == empId).toList();

      setState(() {
        odList = filteredOutDuty; 

        print("Fetched All OutDuty Count: ${allData.length}");
        print("Filtered OutDuty Count (Employee $empId): ${odList.length}");
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch OnDuty data: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Approved":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      case "Pending":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yy').format(date);
  }

  Future<void> showApplyOutDutyDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Submit Out Duty Request"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: inDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "In Date & Time",
                    hintText: "Select In Date & Time",
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        DateTime finalDateTime = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          time.hour,
                          time.minute,
                        );
                        inDateController.text = DateFormat(
                          'yyyy-MM-dd HH:mm',
                        ).format(finalDateTime);
                      }
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: outDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Out Date & Time",
                    hintText: "Select Out Date & Time",
                  ),
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        DateTime finalDateTime = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          time.hour,
                          time.minute,
                        );
                        outDateController.text = DateFormat(
                          'yyyy-MM-dd HH:mm',
                        ).format(finalDateTime);
                      }
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: reasonController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: "Reason",
                    hintText: "Reason for Out Duty",
                  ),
                ),
                const SizedBox(height: 10),
                // ✅ Status Dropdown
                // ✅ Replace Dropdown with dynamic API data
                isStatusLoading
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<StatusMasterModel>(
                      value: selectedStatus,
                      decoration: const InputDecoration(
                        labelText: "Status",
                        border: OutlineInputBorder(),
                      ),
                      items:
                          statusList.map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(status.statusName),
                            );
                          }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedStatus = value;
                          });
                        }
                      },
                    ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (inDateController.text.isEmpty ||
                    outDateController.text.isEmpty ||
                    reasonController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("All fields are required")),
                  );
                  return;
                }

                Employeepostonduitymodel newOD = Employeepostonduitymodel(
                  inDateTime: DateTime.parse(inDateController.text),
                  outDateTime: DateTime.parse(outDateController.text),
                  reason: reasonController.text,
                  isActive: true,
                  status: selectedStatus?.statusName ?? "",
                  statusId: selectedStatus?.statusId ?? 1,
                );

                try {
                  await Employeepostonduityworkflow.createOutDuty(
                    newOD.toJson(),
                  );
                  fetchOnDuty();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Out Duty request submitted")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to submit: $e")),
                  );
                }
              },
              child: const Text("Submit Request"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    backgroundColor: Colors.white, // AppBar background color
    title: const Text(
      "On Duty (OD)",
      style: TextStyle(color: Colors.black),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: ElevatedButton.icon(
          onPressed: showApplyOutDutyDialog,
          icon: const Icon(Icons.add, size: 18),
          label: const Text(
            "Apply",
            style: TextStyle(fontSize: 14),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, // button background color
            foregroundColor: Colors.white, // icon & text color
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0, // remove shadow
          ),
        ),
      ),
    ],
  ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: odList.length,
                itemBuilder: (context, index) {
                  final od = odList[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        "${formatDate(od.inDateTime)} - ${formatDate(od.outDateTime)}",
                      ),
                      subtitle: Text(od.reason),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusColor(od.status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          od.status,
                          style: TextStyle(
                            color: getStatusColor(od.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
    
    );
  }
}
