import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  DateTime selectedDate = DateTime(2025, 8, 1);
  String selectedFilter = "All";
  List<AttendanceDay> generateDays() {
    return List.generate(31, (i) {
      int day = i + 1;
      if (day == 1) return AttendanceDay(day: day, status: AttendanceStatus.Present);
      if (day == 2) return AttendanceDay(day: day, status: AttendanceStatus.absent);
      if (day == 3) return AttendanceDay(day: day, status: AttendanceStatus.leave);
      if (day == 4) return AttendanceDay(day: day, status: AttendanceStatus.halfDay);
      if (day == 5) return AttendanceDay(day: day, status: AttendanceStatus.Present);
      if (day == 6) return AttendanceDay(day: day, status: AttendanceStatus.absent);
      if (day == 7) return AttendanceDay(day: day, status: AttendanceStatus.Present);
      if (day == 8) return AttendanceDay(day: day, status: AttendanceStatus.leave);
      if (day == 9 || day == 10) return AttendanceDay(day: day, status: AttendanceStatus.weekend);
      return AttendanceDay(day: day, status: AttendanceStatus.unknown);
    });
  }

 Future<void> _pickMonthYear() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 1),
      helpText: "Select Month and Year",
    );

    if (picked != null) {
      setState(() {
        selectedDate = DateTime(picked.year, picked.month);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    List<AttendanceDay> days = generateDays();
    if (selectedFilter != "All") {
      days = days.where((d) => statusToString(d.status) == selectedFilter).toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Calendar"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
        
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               
                GestureDetector(
                  onTap: () => _pickMonthYear(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(DateFormat("MMMM yyyy").format(selectedDate),
                            style: const TextStyle(fontSize: 14)),
                        const Icon(Icons.calendar_today, size: 18, color: Colors.blueAccent),
                      ],
                    ),
                  ),
                ),
                DropdownButton<String>(
                  value: selectedFilter,
                  items: const [
                    DropdownMenuItem(value: "All", child: Text("All")),
                    DropdownMenuItem(value: "Present", child: Text("Present")),
                    DropdownMenuItem(value: "Absent", child: Text("Absent")),
                    DropdownMenuItem(value: "Leave", child: Text("Leave")),
                    DropdownMenuItem(value: "Half-Day", child: Text("Half-Day")),
                    DropdownMenuItem(value: "Weekend", child: Text("Weekend")),
                    DropdownMenuItem(value: "Holiday", child: Text("Holiday")),
                    DropdownMenuItem(value: "Unknown", child: Text("Unknown")),
                  ],
                  onChanged: (v) {
                    setState(() {
                      selectedFilter = v!;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final day = days[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: getStatusColor(day.status),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: day.status == AttendanceStatus.unknown
                              ? Colors.black
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _legendBox("Present", Colors.green),
                _legendBox("Absent", Colors.red),
                _legendBox("Leave", Colors.orange),
                _legendBox("Half-Day", Colors.blue),
                _legendBox("Weekend", Colors.grey),
                _legendBox("Holiday", Colors.purple),
                _legendBox("Unknown", Colors.grey.shade300),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _legendBox(String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
enum AttendanceStatus { Present, absent, leave, halfDay, weekend, holiday, unknown }

class AttendanceDay {
  final int day;
  final AttendanceStatus status;
  AttendanceDay({required this.day, required this.status});
}
Color getStatusColor(AttendanceStatus status) {
  switch (status) {
    case AttendanceStatus.Present:
      return Colors.green;
    case AttendanceStatus.absent:
      return Colors.red;
    case AttendanceStatus.leave:
      return Colors.orange;
    case AttendanceStatus.halfDay:
      return Colors.blue;
    case AttendanceStatus.weekend:
      return Colors.grey;
    case AttendanceStatus.holiday:
      return Colors.purple;
    case AttendanceStatus.unknown:
    default:
      return Colors.grey.shade300;
  }
}
String statusToString(AttendanceStatus status) {
  switch (status) {
    case AttendanceStatus.Present:
      return "Present";
    case AttendanceStatus.absent:
      return "Absent";
    case AttendanceStatus.leave:
      return "Leave";
    case AttendanceStatus.halfDay:
      return "Half-Day";
    case AttendanceStatus.weekend:
      return "Weekend";
    case AttendanceStatus.holiday:
      return "Holiday";
    case AttendanceStatus.unknown:
    default:
      return "Unknown";
  }
}
