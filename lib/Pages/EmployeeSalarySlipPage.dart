import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:payrollapp/Models/employeesalaryslipmodel.dart';
import 'package:payrollapp/Workflows/employeesalaryslipworkflow.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class EmployeeSalarySlipPage extends StatefulWidget {
  final int employeeId;
  final int year;
  final int month;

  const EmployeeSalarySlipPage({
    super.key,
    required this.employeeId,
    required this.year,
    required this.month,
  });

  @override
  State<EmployeeSalarySlipPage> createState() => _EmployeeSalarySlipPageState();
}

class _EmployeeSalarySlipPageState extends State<EmployeeSalarySlipPage> {
  late Future<List<EmployeeSalarySlipModel>> _futureSlips;
  final GlobalKey _pdfKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _futureSlips = EmployeeSalarySlipWorkflow().getSalarySlip(
      employeeId: widget.employeeId,
      year: widget.year,
      month: widget.month,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: FutureBuilder<List<EmployeeSalarySlipModel>>(
        future: _futureSlips,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("❌ Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No salary slips available"));
          }

          final slip = snapshot.data!.first;
          final employee =
              slip.employees.isNotEmpty ? slip.employees.first : null;
          final department =
              slip.department.isNotEmpty ? slip.department.first : null;
          final location =
              slip.workLocations.isNotEmpty ? slip.workLocations.first : null;
          final salary =
              slip.salaryDetail.isNotEmpty ? slip.salaryDetail.first : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: RepaintBoundary(
                key: _pdfKey,
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "DigiCode",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(6),
                                  ),

                                  child: Text(
                                    "Pay Slip for ${DateFormat('MMMM, yyyy').format(DateTime.now())}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          _printPdf();
                                        });
                                  },
                                  child: const Text(
                                    "Print",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Image.asset(
                                  "lib/assets/userimg.png",
                                  height: 40,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _infoText(
                                    "Employee Name",
                                    employee?.fullName ?? "-",
                                  ),
                                  _infoText(
                                    "Employee ID",
                                    employee?.employeeCode ?? "-",
                                  ),
                                  _infoText(
                                    "Department",
                                    department?.name ?? "-",
                                  ),
                                  _infoText(
                                    "Work Location",
                                    location?.name ?? "-",
                                  ),
                                  _infoText(
                                    "Date of Joining",
                                    employee?.dateOfJoining
                                            .toLocal()
                                            .toString()
                                            .split(" ")
                                            .first ??
                                        "-",
                                  ),
                                  _infoText(
                                    "Pay Date",
                                    slip.payDate
                                        .toLocal()
                                        .toString()
                                        .split(" ")
                                        .first,
                                  ),
                                  _infoText(
                                    "Pay month",
                                    DateFormat.MMMM().format(DateTime.now()),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.green[50],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Total Net Pay",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "₹${salary?.netPay.toStringAsFixed(2) ?? '0.00'}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Earnings",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const Divider(),
                                _earningRow("Basic", salary?.basicSalary ?? 0),
                                _earningRow("HRA", salary?.hra ?? 0),
                                _earningRow(
                                  "Conveyance",
                                  salary?.conveyanceAllowance ?? 0,
                                ),
                                _earningRow(
                                  "Fixed Allowance",
                                  salary?.fixedAllowance ?? 0,
                                ),
                                _earningRow("Bonus", salary?.bonus ?? 0),
                                _earningRow(
                                  "Leave Encashment",
                                  salary?.leaveEncashment ?? 0,
                                ),
                                _earningRow(
                                  "Special Allowance",
                                  salary?.specialAllowance ?? 0,
                                ),
                                _earningRow(
                                  "Other Allowances",
                                  salary?.otherAllowances ?? 0,
                                ),
                                _earningRow(
                                  "Overtime",
                                  salary?.overtimeAmount ?? 0,
                                ),
                                const Divider(),
                                _earningRow(
                                  "Gross Earnings",
                                  salary?.earnings ?? 0,
                                  isBold: true,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Deductions",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const Divider(),
                                _deductionRow(
                                  "Income Tax",
                                  salary?.deductions ?? 0,
                                ),
                                const Divider(),
                                _deductionRow(
                                  "Total Deductions",
                                  salary?.deductions ?? 0,
                                  isBold: true,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "TOTAL NET PAYABLE",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "₹${salary?.netPay.toStringAsFixed(2) ?? '0.00'}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Text("$label : $value"),
    );
  }

  Widget _earningRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
          Text(
            "₹${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _deductionRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
          Text(
            amount > 0 ? "₹${amount.toStringAsFixed(2)}" : "-",
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _printPdf() async {
    try {
      RenderRepaintBoundary boundary =
          _pdfKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 20));
        return _printPdf();
      }
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final pdf = pw.Document();
      final pdfImage = pw.MemoryImage(pngBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Center(child: pw.Image(pdfImage, fit: pw.BoxFit.contain));
          },
        ),
      );

      await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    } catch (e) {
      print("Error generating PDF: $e");
    }
  }
}
