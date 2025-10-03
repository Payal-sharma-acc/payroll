import 'package:flutter/material.dart';
import 'package:payrollapp/Models/designationmodel.dart';
import 'package:payrollapp/Models/designationpostmodel.dart';
import 'package:payrollapp/Workflows/designationaddworkflow.dart';
import 'package:payrollapp/Pages/designationget.dart';

class designationadd extends StatefulWidget {
  final designationmodel? designationToEdit;

  const designationadd({Key? key, this.designationToEdit}) : super(key: key);

  @override
  State<designationadd> createState() => _designationaddState();
}

class _designationaddState extends State<designationadd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.designationToEdit != null) {
      _titleController.text = widget.designationToEdit!.title;
      _levelController.text = widget.designationToEdit!.level;
    }
  }

  Future<void> _saveDesignation() async {
    if (_formKey.currentState!.validate()) {
      final model = designationPostModel(
        title: _titleController.text.trim(),
        level: _levelController.text.trim(),
      );

      final workflow = designationaddworkflow();
      final result = await workflow.createDesignation(model);

      if (result != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Designationget()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save designation')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.designationToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Add Designation' : 'Add Designation'),
      
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Designation Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _levelController,
                decoration: const InputDecoration(
                  labelText: 'Level',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveDesignation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF417BFB),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isEdit ? 'Update' : 'Save',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
