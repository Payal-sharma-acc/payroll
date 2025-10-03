import 'package:flutter/material.dart';
import 'package:payrollapp/Models/designationmodel.dart';
import 'package:payrollapp/Pages/designationget.dart';

import 'package:payrollapp/Workflows/designationworkflow.dart';

class DesignationForm extends StatefulWidget {
  const DesignationForm({super.key});

  @override
  State<DesignationForm> createState() => _DesignationFormState();
}

class _DesignationFormState extends State<DesignationForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _designationNameController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();

  @override
  void dispose() {
    _designationNameController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  void _onSave() async {
    if (_formKey.currentState!.validate()) {
      final designationName = _designationNameController.text.trim();
      final level = _levelController.text.trim();

      final newDesignation = designationmodel(
        id: 0, 
        title: designationName,
        level: level,
      );

      final workflow = DesignationWorkflow();
      final success = await workflow.addDesignation(newDesignation);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Designation saved successfully")),
        );

  
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Designationget()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save designation")),
        );
      }
    }
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFFFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
               
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Designation",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                        
                          const SizedBox(width: 8),
                         ],
                      ),
                    ],
                  ),
                 const SizedBox(height: 30),
                  RichText(
                    text: const TextSpan(
                      text: "Designation Name ",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      children: [TextSpan(text: "*", style: TextStyle(color: Colors.red))],
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _designationNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter designation name" : null,
                  ),

                  const SizedBox(height: 25),
                  RichText(
                    text: const TextSpan(
                      text: "Level ",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                      children: [TextSpan(text: "*", style: TextStyle(color: Colors.red))],
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _levelController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Please enter level" : null,
                  ),

                  const SizedBox(height: 50),
                  Center(
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: _onSave,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF417BFB),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 45),
                        ),
                        child: const Text("Save"),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),
                  Center(
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: _onCancel,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF417BFB),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 45),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
