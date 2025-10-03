import 'package:flutter/material.dart';
import 'package:payrollapp/Models/payschedulemodel.dart';
import 'package:intl/intl.dart';

class PayScheduleSummary extends StatelessWidget {
  final PayScheduleModel schedule;

  const PayScheduleSummary({Key? key, required this.schedule}) : super(key: key);

  String formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);
  String getMonthYear(DateTime date) => DateFormat('MMMM yyyy').format(date);

  DateTime getNextMonthPayDate() {
    final nextMonth = DateTime(
      schedule.firstPayrollStartFrom.year,
      schedule.firstPayrollStartFrom.month + 1,
    );

    int day = schedule.specificPayDay.clamp(
      1,
      DateUtils.getDaysInMonth(nextMonth.year, nextMonth.month),
    );

    return DateTime(nextMonth.year, nextMonth.month, day);
  }

  DateTime _getLastWorkingDay(int year, int month) {
    DateTime date = DateTime(year, month + 1, 0);
    while (date.weekday == DateTime.saturday || date.weekday == DateTime.sunday) {
      date = date.subtract(const Duration(days: 1));
    }
    return date;
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 160, child: Text("$label:")),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nextPayDate = schedule.payOnType == "LastWorkingDay"
        ? _getLastWorkingDay(
            schedule.firstPayrollStartFrom.year,
            schedule.firstPayrollStartFrom.month + 1,
          )
        : getNextMonthPayDate();

    return Scaffold(
      appBar: AppBar(title: const Text("Pay Schedule")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: const Color(0xFFFFF4E5),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: const [
                    Icon(Icons.warning_amber, color: Colors.orange),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Note: Pay Schedule cannot be edited once you process the first pay run.",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
           Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "This Organisation’s payroll runs on this schedule.",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _infoRow("Pay Frequency", schedule.payFrequency),
                    _infoRow("Working Days", schedule.workWeekDays.join(", ")),
                    if (schedule.salaryBasedOn == "WorkingDays")
                      _infoRow("Working Days", schedule.organizationWorkingDays.toString()),
                    _infoRow(
                      "Pay Day",
                      schedule.payOnType == "LastWorkingDay"
                          ? "Last working day"
                          : "${schedule.specificPayDay}th of every month",
                    ),
                    _infoRow("First Pay Period", getMonthYear(schedule.firstPayrollStartFrom)),
                    _infoRow("First Pay Date", formatDate(schedule.firstPayrollStartFrom)),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
           Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Upcoming Payrolls",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _infoRow(
                      getMonthYear(schedule.firstPayrollStartFrom),
                      "Pay Date: ${formatDate(schedule.firstPayrollStartFrom)}",
                    ),
                    _infoRow(
                      getMonthYear(nextPayDate),
                      "Pay Date: ${formatDate(nextPayDate)}",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
