import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class EmployeeUploadDocumentPage extends StatefulWidget {
  @override
  _EmployeeUploadDocumentPageState createState() =>
      _EmployeeUploadDocumentPageState();
}

class _EmployeeUploadDocumentPageState
    extends State<EmployeeUploadDocumentPage> {
  String? selectedDocument;
  String? pickedFileName;

  List<String> documentTypes = [
    '10th Marksheet',
    '12th Marksheet',
    'Graduation',
    'Post Graduation',
    'Aadhar card',
    'Pan card',
    'Salary slip previous',
  ];

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        pickedFileName = result.files.single.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Documents'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            Image.asset('lib/assets/document.png', width: 150, height: 150),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedDocument,
              hint: Text('Select Document Type'),
              items:
                  documentTypes.map((doc) {
                    return DropdownMenuItem<String>(
                      value: doc,
                      child: Text(doc),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDocument = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: pickFile,
              icon: Icon(Icons.upload_file),
              label: Text('Pick File'),
            ),
            SizedBox(height: 10),
            if (pickedFileName != null)
              Text(
                'Selected File: $pickedFileName',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
          ],
        ),
      ),
    );
  }
}
