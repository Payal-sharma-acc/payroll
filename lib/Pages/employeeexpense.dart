import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class EmployeeExpense extends StatefulWidget {
  @override
  _EmployeeExpenseState createState() => _EmployeeExpenseState();
}

class ExpenseItem {
  String? selectedHead;
  DateTime? startDate;
  DateTime? endDate;
  TextEditingController amountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  File? selectedFile;

  ExpenseItem();
}

class _EmployeeExpenseState extends State<EmployeeExpense> {
  List<ExpenseItem> expenses = [ExpenseItem()];
  List<String> heads = ['Travel', 'Food', 'Stationery', 'Other'];

  String getCurrentDate() => DateFormat("dd-MMM-yyyy").format(DateTime.now());

  Future<void> pickFile(ExpenseItem item) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        item.selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> pickDate(BuildContext context, ExpenseItem item, bool isStart) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          item.startDate = picked;
        } else {
          item.endDate = picked;
        }
      });
    }
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  void _showAddHeadDialog(ExpenseItem item) {
    final TextEditingController newHeadController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create New Expense"),
        content: TextField(
          controller: newHeadController,
          decoration: InputDecoration(hintText: "Enter head name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (newHeadController.text.trim().isNotEmpty) {
                setState(() {
                  heads.insert(heads.length - 1, newHeadController.text.trim());
                  item.selectedHead = newHeadController.text.trim();
                });
                Navigator.pop(context);
              }
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseForm(ExpenseItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Date : ${getCurrentDate()}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            if (expenses.length > 1)
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => setState(() => expenses.remove(item)),
              ),
          ],
        ),
        SizedBox(height: 12),

    
        DropdownButtonFormField<String>(
          value: item.selectedHead,
          items: heads.map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
          onChanged: (value) {
            if (value == "Other") {
              _showAddHeadDialog(item);
            } else {
              setState(() => item.selectedHead = value);
            }
          },
          decoration: _decoration("Expense"),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                readOnly: true,
                decoration: _decoration("Start Date").copyWith(
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                controller: TextEditingController(
                  text: item.startDate != null
                      ? DateFormat("dd-MMM-yyyy").format(item.startDate!)
                      : "",
                ),
                onTap: () => pickDate(context, item, true),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                readOnly: true,
                decoration: _decoration("End Date").copyWith(
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                controller: TextEditingController(
                  text: item.endDate != null
                      ? DateFormat("dd-MMM-yyyy").format(item.endDate!)
                      : "",
                ),
                onTap: () => pickDate(context, item, false),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        TextFormField(
          controller: item.amountController,
          keyboardType: TextInputType.number,
          decoration: _decoration("Enter the amount"),
        ),
        SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () => pickFile(item),
          icon: Icon(Icons.upload_file),
          label: Text(item.selectedFile != null
              ? item.selectedFile!.path.split('/').last
              : "Upload Bill"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        SizedBox(height: 12),
        TextFormField(
          controller: item.remarkController,
          decoration: _decoration("Remark"),
          maxLines: 2,
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => setState(() => expenses.add(ExpenseItem())),
                icon: Icon(Icons.add, color: Colors.white),
                label: Text("Add More"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  print("Head: ${item.selectedHead}");
                  print("Amount: ${item.amountController.text}");
                  print("Start Date: ${item.startDate}");
                  print("End Date: ${item.endDate}");
                  print("Remark: ${item.remarkController.text}");
                  print("File: ${item.selectedFile?.path}");
                  print("-------------------");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Submitted successfully for this expense")),
                  );
                },
                child: Text("Submit"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expenses"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: expenses
              .map(
                (item) => Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: _buildExpenseForm(item),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
