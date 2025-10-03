import 'package:flutter/material.dart';
import 'package:payrollapp/Models/departmentgetmodel.dart';
import 'package:payrollapp/Models/designationmodel.dart';
import 'package:payrollapp/Models/employeelistmodel.dart';
import 'package:payrollapp/Models/worklocationgetmodel.dart';
import 'package:payrollapp/Pages/addemployee.dart';
import 'package:payrollapp/Workflows/departmentgetworkflow.dart';
import 'package:payrollapp/Workflows/designationworkflow.dart';
import 'package:payrollapp/Workflows/employeeworkflowlist.dart';
import 'package:payrollapp/Workflows/worklocationgetworkflow.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  late Future<List<Employeelistmodel>> _employeeFuture;
  String? selectedDepartmentId = '';
  String? selectedDesignationId = '';
  String? selectedWorklocationId = '';
  List<Departmentgetmodel> departmentList = [];
  List<designationmodel> designationList = [];
  List<Worklocationgetmodel> worklocationList = [];
  List<Employeelistmodel> allEmployees = [];

  @override
  void initState() {
    super.initState();
    _employeeFuture = Employeeworkflowlist.getEmployees();
    _employeeFuture.then((data) {
      setState(() {
        allEmployees = data;
      });
    });
    fetchDepartmentList();
    fetchDesignationList();
    fetchWorklocationList();
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

  List<Employeelistmodel> getFilteredEmployees() {
    return allEmployees.where((emp) {
      final matchWorklocation =
          (selectedWorklocationId == null || selectedWorklocationId == '')
              ? true
              : emp.workLocationId.toString() == selectedWorklocationId;
      final matchDepartment =
          (selectedDepartmentId == null || selectedDepartmentId == '')
              ? true
              : emp.departmentId.toString() == selectedDepartmentId;
      final matchDesignation =
          (selectedDesignationId == null || selectedDesignationId == '')
              ? true
              : emp.designationId.toString() == selectedDesignationId;

      return matchWorklocation && matchDepartment && matchDesignation;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee List"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Addemployee()),
                );
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Add Employee"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.file_upload, size: 18),
              label: const Text("Import"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.blueAccent),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Image.asset(
            'lib/assets/employeelist2.png',
            height: 150,
          ), 
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 250,
                    child: DropdownButtonFormField<String>(
                      value: selectedWorklocationId,
                      decoration: const InputDecoration(
                        labelText: 'Work Location',
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: '',
                          child: Text('All Work Locations'),
                        ),
                        ...worklocationList.map((loc) {
                          return DropdownMenuItem<String>(
                            value: loc.id.toString(),
                            child: Text(loc.name),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedWorklocationId = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 250,
                    child: DropdownButtonFormField<String>(
                      value: selectedDepartmentId,
                      decoration: const InputDecoration(
                        labelText: 'Department',
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: '',
                          child: Text('All Departments'),
                        ),
                        ...departmentList.map((dept) {
                          return DropdownMenuItem<String>(
                            value: dept.id.toString(),
                            child: Text(dept.name),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedDepartmentId = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 250,
                    child: DropdownButtonFormField<String>(
                      value: selectedDesignationId,
                      decoration: const InputDecoration(
                        labelText: 'Designation',
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: '',
                          child: Text('All Designations'),
                        ),
                        ...designationList.map((desig) {
                          return DropdownMenuItem<String>(
                            value: desig.id.toString(),
                            child: Text(desig.title),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedDesignationId = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child:
                allEmployees.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : Builder(
                      builder: (context) {
                        final filteredEmployees = getFilteredEmployees();

                        if (filteredEmployees.isEmpty) {
                          return const Center(
                            child: Text('No employees found.'),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: filteredEmployees.length,
                          itemBuilder: (context, index) {
                            final emp = filteredEmployees[index];

                            final departmentName =
                                departmentList
                                    .firstWhere(
                                      (dept) => dept.id == emp.departmentId,
                                      orElse:
                                          () => Departmentgetmodel(
                                            id: 0,
                                            name: 'Unknown',
                                            description: '',
                                          ),
                                    )
                                    .name;

                            final designationTitle =
                                designationList
                                    .firstWhere(
                                      (desig) => desig.id == emp.designationId,
                                      orElse:
                                          () => designationmodel(
                                            id: 0,
                                            title: 'Unknown',
                                            level: '',
                                          ),
                                    )
                                    .title;

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: Text(
                                    emp.fullName.isNotEmpty
                                        ? emp.fullName[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                title: Text(emp.fullName),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Emp Code: ${emp.employeeCode}"),
                                    Text(
                                      "Dept: $departmentName, Desig: $designationTitle",
                                    ),
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    emp.isDirector
                                        ? const Text(
                                          "Director",
                                          style: TextStyle(color: Colors.green),
                                        )
                                        : const Text(""),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            emp.portalAccessEnabled
                                                ? Colors.green[100]
                                                : Colors.red[100],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        emp.portalAccessEnabled
                                            ? "Enabled"
                                            : "Disabled",
                                        style: TextStyle(
                                          color:
                                              emp.portalAccessEnabled
                                                  ? Colors.green
                                                  : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
