import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:payrollapp/Models/designationimportmodel.dart';
import 'package:payrollapp/Models/designationmodel.dart';
import 'package:payrollapp/Pages/designationadd.dart';
import 'package:payrollapp/Pages/designationform.dart';
import 'package:payrollapp/Pages/designationupdate.dart';
import 'package:payrollapp/Workflows/designationimportworkflow.dart';
import 'package:payrollapp/Workflows/designationworkflow.dart';
import 'package:payrollapp/Workflows/designationdeleteworkflow.dart';
import 'package:file_picker/file_picker.dart';

class Designationget extends StatefulWidget {
  const Designationget({super.key});

  @override
  State<Designationget> createState() => _DesignationgetState();
}

class _DesignationgetState extends State<Designationget> {
  List<designationmodel> designationList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDesignations();
  }

  Future<void> fetchDesignations() async {
    try {
      designationList = await DesignationWorkflow.getAllDesignations();
    } catch (e) {
      debugPrint("Error fetching designations: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFFFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Designation',
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
                        onPressed: () {},
                        icon: const Icon(Icons.upload, size: 16),
                        label: const Text("Export"),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                          itemCount: designationList.length,
                          itemBuilder: (context, index) {
                            final item = designationList[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: _designationCard(item),
                            );
                          },
                        ),
              ),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => DesignationForm(
                             
                            ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Add Designation',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF417BFB),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton({required IconData icon, required String label}) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF417BFB),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _designationCard(designationmodel designation) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Designation Name : ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(designation.title),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'update') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  DesignationUpdate(id: designation.id),
                        ),
                      ).then((_) => fetchDesignations());
                    } else if (value == 'delete') {
                      _showDeleteDialog(designation);
                    }
                  },
                  itemBuilder:
                      (BuildContext context) => [
                        const PopupMenuItem(
                          value: 'update',
                          child: Text('Update'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  'Level : ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(designation.level),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(designationmodel designation) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: Text(
              'Are you sure you want to delete "${designation.title}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  final deleted = await DesignationDeleteWorkflow()
                      .deleteDesignation(designation.id);

                  if (deleted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Designation deleted")),
                    );
                    fetchDesignations();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Failed to delete designation"),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
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
      List<DesignationImportModel> result = await workflow.importDesignation(
        file: selectedFile!,
      );

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error importing: $e")));
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
                          Text(
                            "Selected: $fileName",
                            style: const TextStyle(fontSize: 12),
                          ),
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
