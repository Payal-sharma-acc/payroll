import 'package:flutter/material.dart';
import 'package:payrollapp/Models/employeeadvancedpaymnetapprovebymodel.dart';
import 'package:payrollapp/Models/employeeleaveapprovedbymodel.dart';
import 'package:payrollapp/Models/employeeleavegetmodel.dart';
import 'package:payrollapp/Models/employeeleavemodel.dart';
import 'package:payrollapp/Models/employeeleavepostmodel.dart';
import 'package:payrollapp/Models/employeeleavetypemodel.dart';
import 'package:payrollapp/Models/employeeonduitystatusmastermodel.dart';
import 'package:payrollapp/Workflows/employeeleavegetworkflow.dart';
import 'package:payrollapp/Workflows/employeeleavetypeworkflow.dart';
import 'package:payrollapp/Workflows/employeeonduitystatusmasterworkflow.dart';
import 'package:payrollapp/Workflows/employeepostleaveworkflow.dart';
import 'package:payrollapp/Workflows/employeeadvancedpaymnetapprovebyworkflow.dart';

import 'package:payrollapp/utils/token_storage.dart';

class EmployeeLeave extends StatefulWidget {
  const EmployeeLeave({super.key});

  @override
  State<EmployeeLeave> createState() => _EmployeeLeaveState();
}

class _EmployeeLeaveState extends State<EmployeeLeave> {
  late EmployeepostLeaveModel leave;
  List<EmployeeLeavegetModel> leaveHistory = [];
  List<Employeeleavemodel> leaveTypes = [];
  bool isLoading = true;

  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  int? selectedLeaveTypeId;
  String? selectedLeaveTypeName;
  int? employeeId;
  List<ApproverModel> approvers = [];
  ApproverModel? selectedApprover;

  // Status related
  List<StatusMasterModel> statusList = [];
  StatusMasterModel? selectedStatus;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      employeeId = await TokenStorage.getEmployeeId();

      final leaveTypesData = await LeaveTypeWorkflow.getAllLeaveTypes();
      leaveTypes =
          leaveTypesData
              .map(
                (e) => Employeeleavemodel(
                  leaveTypeId: e.leaveTypeId,
                  leaveName: e.leaveName,
                  leaveCode: e.leaveCode,
                  maxLeavesPerYear: e.maxLeavesPerYear ?? 0,
                ),
              )
              .toList();

      leaveHistory = await EmployeeLeavegetWorkflow().getEmployeeLeaves();

      final approverData = await EmployeeRoleMappingWorkflow.fetchApprovers();

      approvers =
          approverData
              .where((mapping) => mapping.requestType == "Leave")
              .expand((mapping) => mapping.approvers)
              .toList();

      if (approvers.isNotEmpty) selectedApprover = approvers.first;

      final statusData = await StatusMasterWorkflow.getAllStatuses();
      statusList = statusData;
      if (statusList.isNotEmpty) selectedStatus = statusList.first;

      setState(() => isLoading = false);
    } catch (e) {
      print("❌ Error loading data: $e");
      setState(() => isLoading = false);
    }
  }

  String getStatusText(int status) {
    switch (status) {
      case 1:
        return "Pending";
      case 2:
        return "Approved";
      case 3:
        return "Rejected";
      default:
        return "Unknown";
    }
  }

  Color getStatusBgColor(int status) {
    switch (status) {
      case 2:
        return Colors.green.shade100;
      case 3:
        return Colors.red.shade100;
      default:
        return Colors.orange.shade100;
    }
  }

  Color getStatusTextColor(int status) {
    switch (status) {
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Leave Request",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: _showApplyLeaveDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "+ Apply Leave",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    _buildLeaveCards(),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Leave History",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          _buildLeaveHistoryTable(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  void _showApplyLeaveDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Apply Leave",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    value: selectedLeaveTypeId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Leave Type",
                    ),
                    items:
                        leaveTypes.map((e) {
                          return DropdownMenuItem(
                            value: e.leaveTypeId,
                            child: Text("${e.leaveName} (${e.leaveCode})"),
                          );
                        }).toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedLeaveTypeId = val;
                        selectedLeaveTypeName =
                            leaveTypes
                                .firstWhere((l) => l.leaveTypeId == val!)
                                .leaveName;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<ApproverModel>(
                    value: selectedApprover,
                    decoration: const InputDecoration(
                      labelText: "Approved By",
                      border: OutlineInputBorder(),
                    ),
                    items:
                        approvers.map((approver) {
                          return DropdownMenuItem(
                            value: approver,
                            child: Text(approver.employeeName),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedApprover = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: fromDateController,
                          decoration: const InputDecoration(
                            labelText: "From Date",
                            hintText: "dd-mm-yyyy",
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              fromDateController.text =
                                  "${picked.day}-${picked.month}-${picked.year}";
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: toDateController,
                          decoration: const InputDecoration(
                            labelText: "To Date",
                            hintText: "dd-mm-yyyy",
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          readOnly: true,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (picked != null) {
                              toDateController.text =
                                  "${picked.day}-${picked.month}-${picked.year}";
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: reasonController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Reason",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<StatusMasterModel>(
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
                      setState(() {
                        selectedStatus = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () async {
                        if (employeeId == null ||
                            selectedLeaveTypeId == null ||
                            fromDateController.text.isEmpty ||
                            toDateController.text.isEmpty ||
                            reasonController.text.trim().isEmpty ||
                            selectedApprover == null ||
                            selectedStatus == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill all fields"),
                            ),
                          );
                          return;
                        }

                        final fromParts = fromDateController.text.split("-");
                        final toParts = toDateController.text.split("-");

                        final fromDate = DateTime(
                          int.parse(fromParts[2]),
                          int.parse(fromParts[1]),
                          int.parse(fromParts[0]),
                        );
                        final toDate = DateTime(
                          int.parse(toParts[2]),
                          int.parse(toParts[1]),
                          int.parse(toParts[0]),
                        );

                        final leave = EmployeepostLeaveModel(
                          employeeId: employeeId!,
                          leaveTypeId: selectedLeaveTypeId!,
                          leaveName: selectedLeaveTypeName!,
                          leaveCode:
                              leaveTypes
                                  .firstWhere(
                                    (l) => l.leaveTypeId == selectedLeaveTypeId,
                                  )
                                  .leaveCode,
                          fromDate: fromDate,
                          toDate: toDate,
                          reason: reasonController.text.trim(),
                          status: selectedStatus!.statusId,
                          approvedBy: selectedApprover!.employeeId,
                          createdOn: DateTime.now(),
                          updatedOn: DateTime.now(),
                          customApproverIds: [selectedApprover!.employeeId],
                        );

                        try {
                          await EmployeepostLeaveWorkflow().applyLeave(leave);
                          Navigator.pop(context);
                          await _loadData();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Leave applied successfully"),
                            ),
                          );
                        } catch (e) {
                          print("❌ Error applying leave: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to apply leave"),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Submit Leave Request",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _leaveCard(String title, int days, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 5),
          Text(
            "$days",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(subtitle, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildLeaveCards() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children:
          leaveTypes.map((leave) {
            return SizedBox(
              width: MediaQuery.of(context).size.width / 3 - 16,
              child: _leaveCard(
                leave.leaveCode,
                leave.maxLeavesPerYear,
                "Available days",
              ),
            );
          }).toList(),
    );
  }

  Widget _buildLeaveHistoryTable() {
    if (leaveHistory.isEmpty) {
      return const Center(child: Text("No leave history found"));
    }

    return Column(
      children:
          leaveHistory.map((leave) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    leave.leaveCode,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(leave.fromDate.split("T")[0]),
                  Text(leave.toDate.split("T")[0]),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: getStatusBgColor(leave.status),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      getStatusText(leave.status),
                      style: TextStyle(
                        color: getStatusTextColor(leave.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
