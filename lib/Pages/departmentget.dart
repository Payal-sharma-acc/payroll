import 'package:flutter/material.dart';
import 'package:payrollapp/Models/departmentgetmodel.dart';
import 'package:payrollapp/Pages/departmentform.dart';
import 'package:payrollapp/Pages/departmentupdate.dart';
import 'package:payrollapp/Workflows/departmentgetworkflow.dart';
import 'package:payrollapp/Workflows/departmentdeleteworkflow.dart';

class Departmentget extends StatefulWidget {
  const Departmentget({super.key});

  @override
  State<Departmentget> createState() => _DepartmentgetState();
}

class _DepartmentgetState extends State<Departmentget> {
  List<Departmentgetmodel> departments = [];

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    final data = await DepartmentgetWorkflow.getDepartments();
    setState(() {
      departments = data;
    });
  }

  Widget _buildDepartmentCard(Departmentgetmodel department) {
    return Card(
      elevation: 7,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Department Name:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    department.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'Update') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  Departmentupdate(departmentId: department.id),
                        ),
                      );
                    } else if (value == 'Delete') {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text(
                              'Are you sure you want to delete this department?',
                            ),
                            actions: [
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed:
                                    () => Navigator.of(context).pop(true),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirmed == true) {
                        final result =
                            await DepartmentDeleteWorkflow.deleteDepartment(
                              department.id,
                            );
                        if (result != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result.message)),
                          );
                          _loadDepartments();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('❌ Failed to delete department'),
                            ),
                          );
                        }
                      }
                    }
                  },
                  itemBuilder:
                      (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'Update',
                          child: Text('Update'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Delete',
                          child: Text('Delete'),
                        ),
                      ],
                  offset: const Offset(20, 40),
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Description: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(child: Text(department.description)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButtonWithText({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white, size: 18),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: const Size(80, 36),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFE0F7FA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Departments",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        _iconButtonWithText(
                          icon: Icons.file_upload,
                          label: "Import",
                          color: Colors.indigo,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 8),
                        _iconButtonWithText(
                          icon: Icons.file_download,
                          label: "Export",
                          color: Colors.indigo,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: ListView.builder(
                    itemCount: departments.length,
                    itemBuilder: (context, index) {
                      return _buildDepartmentCard(departments[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 32,
            height: 50,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Add Department",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DepartmentForm(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
