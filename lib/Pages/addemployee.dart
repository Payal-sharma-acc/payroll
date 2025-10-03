import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payrollapp/Models/departmentgetmodel.dart';
import 'package:payrollapp/Models/designationmodel.dart';
import 'package:payrollapp/Models/employeemodel.dart';
import 'package:payrollapp/Models/payschedulemodel.dart';
import 'package:payrollapp/Models/payseduleaddemployeemodel.dart';
import 'package:payrollapp/Models/worklocationgetmodel.dart';
import 'package:payrollapp/Workflows/departmentgetworkflow.dart';
import 'package:payrollapp/Workflows/designationworkflow.dart';
import 'package:payrollapp/Workflows/employeeworkflow.dart';
import 'package:payrollapp/Workflows/payseduleaddemployeeworkflow.dart';
import 'package:payrollapp/Workflows/worklocationgetworkflow.dart';
import 'package:payrollapp/utils/token_storage.dart';

class Addemployee extends StatefulWidget {
  const Addemployee({super.key});

  @override
  State<Addemployee> createState() => _AddemployeeState();
}

class _AddemployeeState extends State<Addemployee> {
  final _formKey = GlobalKey<FormState>();
  bool isDirector = false;
  bool portalAccess = false;
  String? selectedGender;
  String? selectedDepartmentId;
  String? selectedDesignationId;
  String? selectedWorklocationId;
  String? selectedPayScheduleId;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController dojController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  final List<String> genderOptions = ['Male', 'Female', 'Other'];
  List<Departmentgetmodel> departmentList = [];
  List<designationmodel> designationList = [];
  List<Worklocationgetmodel> worklocationList = [];
  List<Payseduleaddemployeemodel> payScheduleList = [];

  @override
  void initState() {
    super.initState();
    fetchDepartmentList();
    fetchDesignationList();
    fetchWorklocationList();
    fetchPayScheduleList();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    employeeIdController.dispose();
    dojController.dispose();
    emailController.dispose();
    mobileController.dispose();
    super.dispose();
  }
  void fetchPayScheduleList() async {
    try {
      final data = await Payseduleaddemployeeworkflow.getAllPaySchedules();
      setState(() => payScheduleList = data);
    } catch (e) {
      print("Error fetching pay schedules: $e");
    }
  }

  void fetchDepartmentList() async {
    try {
      final data = await DepartmentgetWorkflow.getDepartments();
      setState(() => departmentList = data);
    } catch (e) {
      print("Error fetching departments: $e");
    }
  }

  void fetchDesignationList() async {
    try {
      final data = await DesignationWorkflow.getAllDesignations();
      setState(() => designationList = data);
    } catch (e) {
      print("Error fetching designations: $e");
    }
  }

  void fetchWorklocationList() async {
    try {
      final data = await Worklocationgetworkflow.getWorkLocations();
      setState(() => worklocationList = data);
    } catch (e) {
      print("Error fetching work locations: $e");
    }
  }
  Future<void> _saveEmployee() async {
    if (!_formKey.currentState!.validate()) return;

    DateTime parsedDate;
    try {
      parsedDate = DateFormat('dd-MM-yyyy').parseStrict(dojController.text);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Date Format (dd-MM-yyyy)")),
      );
      return;
    }

    try {
      final fullName =
          '${firstNameController.text} ${middleNameController.text} ${lastNameController.text}'
              .trim();

      final employee = EmployeeModel(
        employeeCode: employeeIdController.text.trim(),
        fullName: fullName,
        dateOfJoining: parsedDate,
        workEmail: emailController.text.trim(),
        mobileNumber: mobileController.text.trim(),
        isDirector: isDirector,
        gender: selectedGender ?? '',
        departmentId: int.tryParse(selectedDepartmentId ?? '') ?? 0,
        designationId: int.tryParse(selectedDesignationId ?? '') ?? 0,
        workLocationId: int.tryParse(selectedWorklocationId ?? '') ?? 0,
        payScheduleId: int.tryParse(selectedPayScheduleId ?? '') ?? 0,
        portalAccessEnabled: portalAccess,
      );

      final result = await EmployeeWorkflow.createEmployeeWithResponse(employee);

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Employee created successfully.'),
          ),
        );

        final newEmployeeId = result['id'] as int?;
        final orgIdFromApi = result['orgId'] as int?;

        if (newEmployeeId != null && orgIdFromApi != null) {
          await TokenStorage.saveEmployeeId(newEmployeeId);
          await TokenStorage.saveOrgId(orgIdFromApi);
          print("✅ Saved EmployeeId=$newEmployeeId, OrgId=$orgIdFromApi");
        } else {
          print("⚠️ Missing employeeId or orgId in API response");
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Something went wrong')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFFFFF), Color.fromARGB(255, 218, 250, 253)],
          stops: [0.3, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              const Expanded(
                child: Text(
                  "Basic Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  _buildHeaderButton('Import', Colors.blue, Colors.white),
                  const SizedBox(width: 8),
                  _buildHeaderButton('Export', Colors.blue, Colors.white),
                ],
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text('Full Name *'),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        'First Name',
                        controller: firstNameController,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTextField(
                        'Middle Name',
                        controller: middleNameController,
                        isRequired: false,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildTextField(
                        'Last Name',
                        controller: lastNameController,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  'Employee ID *',
                  controller: employeeIdController,
                ),
                const SizedBox(height: 12),
                _buildDateField('Date of Joining *', controller: dojController),
                const SizedBox(height: 12),
                _buildTextField('Work Email', controller: emailController),
                const SizedBox(height: 12),
                _buildTextField(
                  'Mobile Number *',
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  value: isDirector,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text(
                    'Employee is a Director/person with substantial interest in the company',
                  ),
                  onChanged: (val) => setState(() => isDirector = val ?? false),
                ),
                const SizedBox(height: 12),
                _buildDropdown(
                  'Gender',
                  genderOptions,
                  selectedGender,
                  (val) => setState(() => selectedGender = val),
                ),
                const SizedBox(height: 12),
                _buildDropdownObject(
                  'Department',
                  departmentList
                      .map((e) => DropdownMenuItem(
                            value: e.id?.toString(),
                            child: Text(e.name ?? ''),
                          ))
                      .toList(),
                  selectedDepartmentId,
                  (val) => setState(() => selectedDepartmentId = val),
                ),
                const SizedBox(height: 12),
                _buildDropdownObject(
                  'Designation',
                  designationList
                      .map((e) => DropdownMenuItem(
                            value: e.id?.toString(),
                            child: Text(e.title ?? ''),
                          ))
                      .toList(),
                  selectedDesignationId,
                  (val) => setState(() => selectedDesignationId = val),
                ),
                const SizedBox(height: 12),
                _buildDropdownObject(
                  'Work Location',
                  worklocationList
                      .map((e) => DropdownMenuItem(
                            value: e.id?.toString(),
                            child: Text(e.name ?? ''),
                          ))
                      .toList(),
                  selectedWorklocationId,
                  (val) => setState(() => selectedWorklocationId = val),
                ),
                const SizedBox(height: 12),
                _buildDropdownObject(
                  'Pay Schedule',
                  payScheduleList
                      .map((e) => DropdownMenuItem(
                            value: e.id?.toString(),
                            child: Text(e.id?.toString() ?? ''),
                          ))
                      .toList(),
                  selectedPayScheduleId,
                  (val) => setState(() => selectedPayScheduleId = val),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: portalAccess,
                  title: const Text('Enable Portal Access'),
                  onChanged: (val) => setState(() => portalAccess = val),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _saveEmployee,
                        child: const Text(
                          'Save and continue',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return 'Required';
        }
        return null;
      },
    );
  }

  Widget _buildDateField(
    String label, {
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'dd-MM-yyyy',
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1990),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          controller.text = DateFormat('dd-MM-yyyy').format(picked);
        }
      },
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Required' : null,
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String? selectedValue,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      value: selectedValue,
      onChanged: onChanged,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      validator: (value) => value == null ? 'Required' : null,
    );
  }

  Widget _buildDropdownObject(
    String label,
    List<DropdownMenuItem<String>> items,
    String? selectedValue,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      value: selectedValue,
      onChanged: onChanged,
      items: items,
      validator: (value) => value == null ? 'Required' : null,
    );
  }

  Widget _buildHeaderButton(String text, Color color, Color textColor) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      onPressed: () {},
      child: Text(text),
    );
  }
}
