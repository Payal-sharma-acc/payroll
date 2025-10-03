import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:payrollapp/Models/designationimportmodel.dart';
import 'package:payrollapp/Pages/designationform.dart';
import 'package:payrollapp/Workflows/designationexportworkflow.dart';
import 'package:payrollapp/Workflows/designationimportworkflow.dart'; 
import 'package:file_picker/file_picker.dart';

class Designation extends StatelessWidget {
  const Designation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFFFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
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
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF417BFB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        onPressed: () {
                          showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: "Import",
                            barrierColor: Colors.transparent,
                            transitionDuration: const Duration(
                              milliseconds: 400,
                            ),
                            pageBuilder: (context, anim1, anim2) {
                              return const SizedBox();
                            },
                            transitionBuilder: (context, anim1, anim2, child) {
                              return Stack(
                                children: [
                            
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 5,
                                        sigmaY: 5,
                                      ),
                                      child: Container(
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                  ),
                            
                                  SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: anim1,
                                        curve: Curves.easeOut,
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.8,
                                        child: const ImportPopup(),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.download, size: 16),
                        label: const Text("Import"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF417BFB),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        onPressed: () {showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: "export",
                            barrierColor: Colors.transparent,
                            transitionDuration: const Duration(
                              milliseconds: 400,
                            ),
                            pageBuilder: (context, anim1, anim2) {
                              return const SizedBox();
                            },
                            transitionBuilder: (context, anim1, anim2, child) {
                              return Stack(
                                children: [
                            
                                  GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 5,
                                        sigmaY: 5,
                                      ),
                                      child: Container(
                                        color: Colors.black.withOpacity(0.2),
                                      ),
                                    ),
                                  ),
                            
                                  SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: anim1,
                                        curve: Curves.easeOut,
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.8,
                                        child: const ExportPopup(),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.upload, size: 16),
                        label: const Text("Export"),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 30),
              Center(
                child: Image.asset('lib/assets/designation1.png', height: 300),
              ),

              const SizedBox(height: 120),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF417BFB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 14,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DesignationForm(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Designation"),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class ImportPopup extends StatefulWidget {
  const ImportPopup({super.key});

  @override
  State<ImportPopup> createState() => _ImportPopupState();
}

class _ImportPopupState extends State<ImportPopup> {
  File? selectedFile;
  String? fileName;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'], 
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
        fileName = result.files.single.name;
      });
    }
  }

  Future<void> saveFile() async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a file first")),
      );
      return;
    }

    try {
      final workflow = DesignationImportWorkflow();
      List<DesignationImportModel> result =
          await workflow.importDesignation(file: selectedFile!);

      if (result.isNotEmpty) {
        Navigator.pop(context, result); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Designation imported successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Import failed. Try again!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error importing: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(17),
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Import Data',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Upload a file to get Started",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('lib/assets/folder.png', height: 100),
                        const Text(
                          'Drag and drop your file here',
                          style: TextStyle(fontSize: 10),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF417BFB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          onPressed: pickFile,
                          child: const Text("Browse files"),
                        ),
                        if (fileName != null) ...[
                          const SizedBox(height: 8),
                          Text("Selected: $fileName",
                              style: const TextStyle(fontSize: 12)),
                        ],
                        const SizedBox(height: 8),
                        const Text(
                          "Supported files: .xlsx\nMax file size: 10MB",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF417BFB),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: saveFile,
                        child: const Text("Save"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: -70,
              bottom: -10,
              child: Image.asset('lib/assets/import.png', height: 400),
            ),
          ],
        ),
      ),
    );
  }
}
class ExportPopup extends StatefulWidget {
  const ExportPopup({super.key});

  @override
  State<ExportPopup> createState() => _ExportPopupState();
}

class _ExportPopupState extends State<ExportPopup> {
  String exportFormat = '.xlsx'; // default
  String maxFileSize = '10MB';   // default
  bool isExporting = false;      // track export state

  Future<void> exportData(BuildContext context) async {
    setState(() => isExporting = true);
    
    try {
      await DesignationExportWorkflow.exportDesignation();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("File downloaded successfully!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error exporting: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(17),
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Export Data',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Download a file to analyze",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('lib/assets/download.png', height: 100),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF417BFB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          onPressed: isExporting ? null : () => exportData(context),
                          child: isExporting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text("Download"),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Supported files: $exportFormat\nMax file size: $maxFileSize",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12, 
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Close",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: -60,
              bottom: -20,
              child: Image.asset('lib/assets/import.png', height: 350),
            ),
          ],
        ),
      ),
    );
  }
}