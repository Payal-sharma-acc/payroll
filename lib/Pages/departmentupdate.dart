import 'package:flutter/material.dart';
import 'package:payrollapp/Pages/departmentget.dart';
import 'package:payrollapp/Workflows/departmentupdateworkflow.dart';
import 'package:payrollapp/Models/departmentupdatemodel.dart';

class Departmentupdate extends StatefulWidget {
  final int departmentId;

  const Departmentupdate({super.key, required this.departmentId});

  @override
  State<Departmentupdate> createState() => _DepartmentupdateState();
}

class _DepartmentupdateState extends State<Departmentupdate> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _adminUserIdController = TextEditingController();

  bool _isLoading = false;
  bool _isFetching = true;

  @override
  void initState() {
    super.initState();
    _loadDepartmentData();
  }

  Future<void> _loadDepartmentData() async {
    final Departmentupdatemodel? department =
        await Departmentupdateworkflow.fetchDepartmentById(widget.departmentId);

    if (department != null) {
      _nameController.text = department.name;
      _descriptionController.text = department.description;
      _adminUserIdController.text = department.id.toString();
      print("Admin User ID: ${department.id}");
    } else {
      print("❌ Department data not found for ID: ${widget.departmentId}");
    }
    setState(() {
      _isFetching = false;
    });
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    final Departmentupdatemodel? response =
        await Departmentupdateworkflow.updateDepartment(
          id: widget.departmentId,
          name: _nameController.text,
          description: _descriptionController.text,
          adminUserId: _adminUserIdController.text,
        );

    setState(() {
      _isLoading = false;
    });

    if (response != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.message)));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Departmentget()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Update failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Update Department")),
      body:
          _isFetching
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Department Name",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _adminUserIdController,
                      decoration: const InputDecoration(
                        labelText: "Admin User ID",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submit,
                        child:
                            _isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text("Update Department"),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
