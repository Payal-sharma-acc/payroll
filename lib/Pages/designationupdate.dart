import 'package:flutter/material.dart';
import 'package:payrollapp/Models/designationupdatemodel.dart';
import 'package:payrollapp/Workflows/designationupdateworkflow.dart';

class DesignationUpdate extends StatefulWidget {
  final int id;

  const DesignationUpdate({super.key, required this.id});

  @override
  State<DesignationUpdate> createState() => _DesignationUpdateState();
}

class _DesignationUpdateState extends State<DesignationUpdate> {
  late TextEditingController _titleController;
  late TextEditingController _levelController;
  bool isLoading = true;
  late Designationupdatemodel _designation;

  final workflow = designationupdateworkflow();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _levelController = TextEditingController();
    loadData();
  }

  Future<void> loadData() async {
    final data = await workflow.getDesignationById(widget.id);
    if (data != null) {
      setState(() {
        _designation = data;
        _titleController.text = _designation.title;
        _levelController.text = _designation.level;
        isLoading = false;
      });
    }
  }

  Future<void> _save() async {
    final updated = Designationupdatemodel(
      id: _designation.id,
      title: _titleController.text.trim(),
      level: _levelController.text.trim(),
    );

    final success = await workflow.updateDesignation(updated);
    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Designation updated successfully')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFFFC),
      appBar: AppBar(
        title: const Text("Update Designation"),
        backgroundColor: const Color(0xFF417BFB),
        foregroundColor: Colors.white,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Edit Designation",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF417BFB),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Designation Title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.title),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _levelController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Designation Level',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.format_list_numbered),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF417BFB),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Update",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
