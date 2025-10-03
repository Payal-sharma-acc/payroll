import 'package:flutter/material.dart';
import 'package:payrollapp/Models/employeeadvancedpaymentgetmodel.dart';
import 'package:payrollapp/Models/employeeadvancedpaymnetapprovebymodel.dart';
import 'package:payrollapp/Models/employeeadvancedpaymnetmodel.dart';
import 'package:payrollapp/Workflows/employeeadvancedpaymentgetworkflow.dart';
import 'package:payrollapp/Workflows/employeeadvancedpaymnetapprovebyworkflow.dart';
import 'package:payrollapp/Workflows/employeeadvancedpaymnetworkflow.dart';
import 'package:payrollapp/utils/token_storage.dart';

class EmployeeAdvancePaymentRequestPage extends StatefulWidget {
  const EmployeeAdvancePaymentRequestPage({super.key});

  @override
  State<EmployeeAdvancePaymentRequestPage> createState() =>
      _EmployeeAdvancePaymentRequestPageState();
}

class _EmployeeAdvancePaymentRequestPageState
    extends State<EmployeeAdvancePaymentRequestPage> {
  List<EmployeeAdvancePaymentgetmodel> advanceRequests = [];
  bool isLoading = true;
  List<ApproverModel> approvers = [];
  ApproverModel? selectedApprover;
  List<EmployeeRoleMappingModel> allApproverMappings = [];


  final TextEditingController amountController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController installmentsController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController approvedController = TextEditingController();
  final TextEditingController installmentamountController =
      TextEditingController();
  DateTime? selectedDate;
  String? paymentType;

  int? employeeId;

  @override
  void initState() {
    super.initState();
    _loadEmployeeId();
    _fetchApprovers();
  }

  Future<void> _fetchApprovers() async {
  try {
    final data = await EmployeeRoleMappingWorkflow.fetchApprovers();
    setState(() {
      allApproverMappings = data; 
      approvers = data
          .where((e) => e.requestType == "AdvancePayment")
          .expand((e) => e.approvers)
          .toList();

      if (approvers.isNotEmpty) selectedApprover = approvers.first;
    });
  } catch (e) {
    print("❌ Error loading approvers: $e");
  }
}

  Future<void> _loadEmployeeId() async {
    final id = await TokenStorage.getEmployeeId();
    if (id != null) {
      setState(() => employeeId = id);
      _fetchAdvanceRequests();
    } else {
      print("❌ EmployeeId not found. User may need to login.");
    }
  }

  Future<void> _fetchAdvanceRequests() async {
    if (employeeId == null) return;

    setState(() => isLoading = true);
    try {
      final data =
          await EmployeeAdvancePaymentgetWorkflow.getAdvancePayments(
            employeeId!,
          );
      setState(() {
        advanceRequests = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("❌ Error fetching data: $e");
    }
  }

  void _openAdvanceRequestPopup() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: const Text(
              "Apply for Advance Payment",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Requested Amount (₹)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: reasonController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: "Reason for Advance",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(
                      text:
                          selectedDate == null
                              ? ""
                              : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                    ),
                    decoration: InputDecoration(
                      labelText: "Preferred Repayment Date",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null)
                            setState(() => selectedDate = picked);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: paymentType,
                    decoration: const InputDecoration(
                      labelText: "Advance Payment Type",
                      border: OutlineInputBorder(),
                    ),
                    items:
                        ["Bank Transfer", "Cash", "Cheque", "UPI"]
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                    onChanged: (value) => setState(() => paymentType = value),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: installmentsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Number of Installments",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: commentController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "comments",
                      border: OutlineInputBorder(),
                    ),
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
                  TextField(
                    controller: installmentamountController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Installment Amount",
                      border: OutlineInputBorder(),
                    ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  if (amountController.text.isEmpty ||
                      reasonController.text.isEmpty ||
                      installmentsController.text.isEmpty ||
                      paymentType == null ||
                      selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("⚠️ Please fill all fields"),
                      ),
                    );
                    return;
                  }

                  final model = Employeeadvancedpaymentmodel(
                    employeeId: employeeId!,
                    advancePaymentAmount:
                        double.tryParse(amountController.text) ?? 0,
                    advancePaymentType: paymentType!,
                    noOfInstallments:
                        int.tryParse(installmentsController.text) ?? 1,
                    installmentAmount:
                        (double.tryParse(amountController.text) ?? 0) /
                        (int.tryParse(installmentsController.text) ?? 1),
                    repaymentStartDate: selectedDate!,
                    reason: reasonController.text,
                    comments: commentController.text,
                    customApproverIds:
                        selectedApprover != null
                            ? [selectedApprover!.employeeId]
                            : [],
                  );

                  final success =
                      await EmployeeAdvancedPaymentWorkflow.createAdvancePayment(
                        model,
                      );

                  if (success) {
                    Navigator.pop(context);
                    _fetchAdvanceRequests();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("✅ Advance request submitted"),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("❌ Failed to submit request"),
                      ),
                    );
                  }
                },
                child: const Text("Submit Request",style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   appBar: AppBar(
    backgroundColor: Colors.white, // AppBar background color
    title: const Text(
      "Advance Salary",
      style: TextStyle(color: Colors.black),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: ElevatedButton.icon(
          onPressed: _openAdvanceRequestPopup,
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
              : SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.all(10),
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "⚠️ Advance Salary Rules",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                               
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text("• Maximum advance amount: ₹50,000"),
                            const Text(
                              "• Or up to 30% of your monthly salary (whichever is lower)",
                            ),
                            const Text(
                              "• One active request at a time is allowed",
                            ),
                            const Text(
                              "• All requests are subject to approval by HR/Admin",
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Your Advance Requests",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    advanceRequests.isEmpty
                        ? const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text("No advance requests yet."),
                        )
                        : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: advanceRequests.length,
                          itemBuilder: (context, index) {
                            final req = advanceRequests[index];
                            return Card(
                              margin: const EdgeInsets.all(8),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Amount: ₹${req.advancePaymentAmount}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Requested on: ${req.createdOn.toLocal().toString().split(' ')[0]}",
                                    ),
                                    Text(
                                      "Installments: ${req.noOfInstallments} month(s)",
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "Installment Plan:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ...req.installments.map((inst) {
                                      return Text(
                                        "Installment ${inst.installmentNumber}: ₹${inst.installmentAmount} | Due: ${inst.dueDate.toLocal().toString().split(' ')[0]}",
                                      );
                                    }).toList(),
                                    const SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.yellow.shade600,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          req.isFullyRepaid
                                              ? "Repaid"
                                              : "Pending",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  ],
                ),
              ),
    );
  }
}
