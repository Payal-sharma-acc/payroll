import 'dart:convert'; // ✅ added for jsonEncode
import 'package:flutter/material.dart';
import 'package:payrollapp/Models/salaryconfiggetmodel.dart';
import 'package:payrollapp/Models/salarydetailmodel.dart';
import 'package:payrollapp/Workflows/salaryconfiggetworkflow.dart';
import 'package:payrollapp/Workflows/salarydetailworkflow.dart';
import 'package:payrollapp/Models/employeedetailsmodel.dart';
import 'package:payrollapp/Workflows/employeedetailsworkflow.dart';
import 'package:payrollapp/utils/token_storage.dart';

class SalaryDetailsScreen extends StatefulWidget {
  final String orgId;

  const SalaryDetailsScreen({Key? key, required this.orgId}) : super(key: key);

  @override
  State<SalaryDetailsScreen> createState() => _SalaryDetailsScreenState();
}

class _SalaryDetailsScreenState extends State<SalaryDetailsScreen> {
  final Salarydetailworkflow service = Salarydetailworkflow();
  List<SalaryComponent> earnings = [];
  List<SalaryComponent> deductions = [];
  double basicSalary = 0;
  bool loading = false;
  bool saving = false;
  Employeedetailsmodel? employeeDetails;
  bool loadingEmployee = false;
  int? empId;
  List<Salaryconfiggetmodel> salaryConfig = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      empId = await TokenStorage.getEmployeeId();
      if (empId != null) {
        await fetchEmployeeAndSalary(empId!);
      } else {
        print("Employee ID not found in TokenStorage");
      }
    });
  }

  Future<void> fetchEmployeeAndSalary(int empId) async {
    setState(() {
      loadingEmployee = true;
      loading = true;
    });

    try {
      final orgIdInt =
          int.tryParse(widget.orgId) ?? await TokenStorage.getOrgId() ?? 0;
      if (orgIdInt == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OrgId not found.")),
        );
        return;
      }

      final configData =
          await SalaryConfiggetWorkflow().getConfigByOrg(orgIdInt);
      setState(() {
        salaryConfig = configData;
      });
      print("Org Components Response: ${jsonEncode(configData.map((c) => c.toJson()).toList())}");

      final emp = await EmployeedetailsWorkflow.getEmployeeById(empId);
      if (emp != null) {
        setState(() => employeeDetails = emp);
        print("Employee Details Response: ${jsonEncode(emp.toJson())}");
      }
    
    } catch (e) {
      print("Error fetching employee or salary data: $e");
    } finally {
      setState(() {
        loadingEmployee = false;
        loading = false;
      });
    }
  }

  double get totalEarnings =>
      earnings.fold(0, (sum, e) => sum + e.monthly);
  double get totalDeductions =>
      deductions.fold(0, (sum, d) => sum + d.monthly);
  double get netPay => totalEarnings - totalDeductions;

  void updateBasicSalary(String value) {
    final newBasic = double.tryParse(value) ?? 0;
    setState(() {
      basicSalary = newBasic;
      earnings = earnings.map((item) {
        if (item.componentName.toLowerCase() == "basicsalary") {
          item.fixedAmount = newBasic;
          item.monthly = newBasic;
          item.annual = newBasic * 12;
        } else if (item.calculationType == 2) {
          item.monthly = (newBasic * item.percentageValue) / 100;
          item.annual = item.monthly * 12;
        }
        return item;
      }).toList();

      deductions = deductions.map((item) {
        if (item.calculationType == 2) {
          item.monthly = (newBasic * item.percentageValue) / 100;
          item.annual = item.monthly * 12;
        }
        return item;
      }).toList();
    });
  }

  Future<void> handleSave() async {
    if (employeeDetails == null || employeeDetails!.id == null) return;

    setState(() => saving = true);
    final allComponents = [...earnings, ...deductions];

    final payload = {
      "employeeId": employeeDetails!.id, 
      "orgId": widget.orgId,
      "month": DateTime.now().month,
      "year": DateTime.now().year,
      "basicSalary": basicSalary,
      "netPay": netPay,
      "components": allComponents.map((c) => c.toJson()).toList(),
    };
    print("Save Salary Payload: ${jsonEncode(payload)}");

    try {
      await service.saveSalaryDetails(payload);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Salary details saved successfully")),
      );
      if (empId != null) await fetchEmployeeAndSalary(empId!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving salary details: $e")),
      );
    } finally {
      setState(() => saving = false);
    }
  }

  Widget buildTable(String title, List<SalaryComponent> data, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Container(
            color: color.withOpacity(0.2),
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          ...data.map(
            (item) => ListTile(
              title: Text(item.componentName),
              subtitle: Text(
                "Calc: ${item.calculationType == 2 ? "Percentage" : "Fixed"}",
              ),
              trailing: SizedBox(
                width: 120,
                child: TextFormField(
                  initialValue: item.componentName.toLowerCase() == "basicsalary"
                      ? basicSalary.toStringAsFixed(2)
                      : item.monthly.toStringAsFixed(2),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    if (item.componentName.toLowerCase() == "basicsalary") {
                      updateBasicSalary(val);
                    } else {
                      final monthly = double.tryParse(val) ?? 0;
                      setState(() {
                        item.monthly = monthly;
                        item.annual = monthly * 12;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              "Total $title",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              "₹ ${(title == "Earnings"
                      ? totalEarnings
                      : totalDeductions).toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading || loadingEmployee) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Salary Details")),
      body: RefreshIndicator(
        onRefresh: () async {
          if (empId != null) await fetchEmployeeAndSalary(empId!);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Employee Summary",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      if (employeeDetails != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Code: ${employeeDetails!.employeeCode}"),
                            Text("Name: ${employeeDetails!.fullName}"),
                            Text("Email: ${employeeDetails!.workEmail}"),
                            Text(
                              "Department ID: ${employeeDetails!.departmentId}",
                            ),
                          ],
                        )
                      else
                        const Text("No employee details available"),
                    ],
                  ),
                ),
              ),
              buildTable("Earnings", earnings, Colors.green),
              buildTable("Deductions", deductions, Colors.red),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Text(
                        "Net Pay (Monthly): ₹${netPay.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("Annual: ₹${(netPay * 12).toStringAsFixed(2)}"),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: saving ? null : handleSave,
                child: saving
                    ? const CircularProgressIndicator()
                    : const Text("Save and Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
