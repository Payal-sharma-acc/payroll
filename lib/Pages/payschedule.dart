import 'package:flutter/material.dart';
import 'package:payrollapp/Models/payschedulemodel.dart';
import 'package:payrollapp/Pages/payschedulesummary.dart';
import 'package:payrollapp/Workflows/payschduleworkflow.dart';

class PaySchedule extends StatefulWidget {
  const PaySchedule({Key? key}) : super(key: key);

  @override
  State<PaySchedule> createState() => _PayScheduleState();
}

class _PayScheduleState extends State<PaySchedule> {
  final List<String> weekDays = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  List<bool> selectedDays = List.filled(7, false);
  bool isActualDays = true;
  int workingDays = 22;
  bool payOnLastWorkingDay = false;
  int payDay = 7;
  DateTime selectedMonth = DateTime.now();
  DateTime selectedDate = DateTime.now();
  String scheduleName = '';
  String payFrequency = 'Monthly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pay Schedule")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "Select your work week",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(weekDays.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(
                        weekDays[index],
                        style: const TextStyle(fontSize: 12),
                      ),
                      selected: selectedDays[index],
                      onSelected:
                          (_) => setState(
                            () => selectedDays[index] = !selectedDays[index],
                          ),
                      selectedColor: Colors.deepPurple.shade100,
                      labelStyle: TextStyle(
                        color:
                            selectedDays[index]
                            ? Colors.deepPurple
                                : Colors.black,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),

                  );
                }),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              "Calculate monthly salary based on",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            RadioListTile(
              value: true,
              groupValue: isActualDays,
              onChanged: (_) => setState(() => isActualDays = true),
              title: const Text("Actual days in a month"),
            ),
            RadioListTile(
              value: false,
              groupValue: isActualDays,
              onChanged: (_) => setState(() => isActualDays = false),
              title: Row(
                children: [
                  const Expanded(child: Text("Organization working days")),

                  if (!isActualDays)
                    SizedBox(
                      width: 60,
                      child: TextFormField(
                        initialValue: workingDays.toString(),
                        onChanged:
                            (val) => setState(() {
                              workingDays = int.tryParse(val) ?? workingDays;
                            }),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(isDense: true),
                      ),
                    ),
                ],
              ),
            ),

            const Divider(height: 32),
            const Text("Pay on", style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile(
              value: true,
              groupValue: payOnLastWorkingDay,
              onChanged: (_) => setState(() => payOnLastWorkingDay = true),
              title: const Text("The last working day of every month"),
            ),
            RadioListTile(
              value: false,
              groupValue: payOnLastWorkingDay,
              onChanged: (_) => setState(() => payOnLastWorkingDay = false),
              title: Row(
                children: [
                  const Text("Day"),
                  const SizedBox(width: 8),
                  if (!payOnLastWorkingDay)
                    SizedBox(
                      width: 50,
                      child: TextFormField(
                        initialValue: payDay.toString(),
                        onChanged:
                            (val) => setState(() {
                              payDay = int.tryParse(val) ?? 1;
                            }),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(isDense: true),
                      ),
                    ),
                  const SizedBox(width: 8),
                  const Text("of every month"),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 8, top: 4),
              child: Text(
                "Note: When payday falls on a non-working day or a holiday, employees will get paid on the previous working day.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),

            const Divider(height: 32),
            const Text(
              "Payroll Start & First Pay Date",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedMonth,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                        helpText: "Pick Payroll Start Month",
                      );
                      if (picked != null) {
                        setState(() => selectedMonth = picked);
                      }
                    },
                    child: Text(
                      "Select Start Month: ${selectedMonth.month}-${selectedMonth.year}",
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                    child: Text(
                      "Pay Date: ${selectedDate.toLocal()}".split(' ')[0],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final selectedWeekDays = <String>[];
                    for (int i = 0; i < selectedDays.length; i++) {
                      if (selectedDays[i]) selectedWeekDays.add(weekDays[i]);
                    }
                    final model = PayScheduleModel(
                      name: scheduleName,
                      workWeekDays: selectedWeekDays,
                      salaryBasedOn:
                          isActualDays ? "ActualDays" : "WorkingDays",
                      organizationWorkingDays: isActualDays ? 0 : workingDays,
                      payOnType:
                          payOnLastWorkingDay
                              ? "LastWorkingDay"
                              : "SpecificDay",
                      specificPayDay: payOnLastWorkingDay ? 0 : payDay,
                      firstPayrollStartFrom: selectedMonth,
                      payFrequency: payFrequency,
                    );

                    final workflow = PayScheduleWorkflow();
                    final success = await workflow.createPaySchedule(model);

                    if (success) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => PayScheduleSummary(schedule: model),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Failed to save Pay Schedule"),
                        ),
                      );
                    }
                  },
                  child: const Text("Save"),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
