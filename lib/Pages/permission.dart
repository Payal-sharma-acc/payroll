import 'package:flutter/material.dart';
import 'package:payrollapp/Models/employeelistmodel.dart';
import 'package:payrollapp/Models/permissionmodel.dart';
import 'package:payrollapp/Pages/permissiongetdata.dart';
import 'package:payrollapp/Workflows/employeelistworkflow.dart';
import 'package:payrollapp/Workflows/permissionworkflow.dart';

class Permission extends StatefulWidget {
  const Permission({super.key});

  @override
  State<Permission> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<Permission> {
  List<Employeelistmodel> employeeList = [];
  Employeelistmodel? selectedEmployee;
  bool isSaving = false;
  String? selectedModule;

  final List<String> modules = [
    "Employee",
    "Salary",
    "Attendance",
    "Pay Schedule",
    "Permission",
    "Work Location",
    "Payroll Run",
  ];

  final Map<String, Map<String, bool>> permissions = {};

  @override
  void initState() {
    super.initState();
    for (var module in modules) {
      permissions[module] = {
        "view": false,
        "create": false,
        "edit": false,
        "delete": false,
      };
    }
    loadEmployees();
  }

  Future<void> loadEmployees() async {
    try {
      final workflow = Employeeidworkflow();
      final employees = await workflow.fetchEmployees();

      if (!mounted) return;
      setState(() {
        employeeList = employees;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load employees")),
      );
    }
  }

  Widget buildToggle(String title, String action, String module) {
    return SwitchListTile(
      title: Text(title),
      value: permissions[module]?[action] ?? false,
      activeColor: const Color.fromARGB(255, 49, 125, 239), 
      onChanged: (bool value) {
        setState(() {
          permissions[module]?[action] = value;
        });
      },
    );
  }

  Future<void> savePermissions() async {
    if (selectedEmployee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an employee.")),
      );
      return;
    }

    setState(() => isSaving = true);

    final List<Permissionmodel> payload = permissions.entries.map((entry) {
      return Permissionmodel(
        adminUserId: selectedEmployee!.id,
        moduleName: entry.key,
        canView: entry.value["view"] ?? false,
        canCreate: entry.value["create"] ?? false,
        canEdit: entry.value["edit"] ?? false,
        canDelete: entry.value["delete"] ?? false,
      );
    }).toList();

    try {
      final workflow = PermissionWorkflow();
      await workflow.createAllPermissions(payload);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permissions saved successfully.")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Permissiongetdata(adminUserId: selectedEmployee!.id),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving permissions: $e")),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF6FA),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Permission",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.blue.shade50,
                      child: InkWell(
                        onTap: () {
                          // Handle import
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: const [
                              Icon(Icons.download, color: Colors.blue),
                              SizedBox(height: 8),
                              Text('Import'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      color: Colors.green.shade50,
                      child: InkWell(
                        onTap: () {
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: const [
                              Icon(Icons.upload, color: Colors.green),
                              SizedBox(height: 8),
                              Text('Export'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<Employeelistmodel>(
                      value: selectedEmployee,
                      decoration: const InputDecoration(
                        labelText: "Select User",
                        border: OutlineInputBorder(),
                      ),
                      items: employeeList.map((employee) {
                        return DropdownMenuItem(
                          value: employee,
                          child: Text(employee.fullName),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => selectedEmployee = value),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedModule,
                      decoration: const InputDecoration(
                        labelText: "Select Module",
                        border: OutlineInputBorder(),
                      ),
                      items: modules
                          .map((module) =>
                              DropdownMenuItem(value: module, child: Text(module)))
                          .toList(),
                      onChanged: (value) => setState(() => selectedModule = value),
                    ),
                    const SizedBox(height: 20),
                    if (selectedModule != null)
                      Column(
                        children: [
                          buildToggle("Can View", "view", selectedModule!),
                          buildToggle("Can Create", "create", selectedModule!),
                          buildToggle("Can Edit", "edit", selectedModule!),
                          buildToggle("Can Delete", "delete", selectedModule!),
                           ],
                      ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: isSaving ? null : savePermissions,
                          child: isSaving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text("Save"),
                        ),
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Available Users",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 200,
                child: employeeList.isEmpty
                    ? const Center(child: Text("No employees found."))
                    : ListView.builder(
                        itemCount: employeeList.length,
                        itemBuilder: (context, index) {
                          final emp = employeeList[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: ListTile(
                              title: Text(emp.fullName),
                              subtitle: Text("ID: ${emp.id}"),
                              onTap: () {
                                setState(() {
                                  selectedEmployee = emp;
                                });
                              },
                              trailing: selectedEmployee?.id == emp.id
                                  ? const Icon(Icons.check_circle, color: Colors.green)
                                  : null,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
