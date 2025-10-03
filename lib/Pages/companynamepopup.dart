import 'package:flutter/material.dart';
import 'package:payrollapp/Models/companynamepopupmodel.dart';
import 'package:payrollapp/Workflows/companynamepopupworkflow.dart';

class Companynamepopup extends StatefulWidget {
  const Companynamepopup({super.key});

  @override
  State<Companynamepopup> createState() => _CompanynamepopupState();

  static Future<Companynamepopupmodel?> show(BuildContext context) {
    return showDialog<Companynamepopupmodel>(
      context: context,
      builder: (context) => const Companynamepopup(),
    );
  }
}

class _CompanynamepopupState extends State<Companynamepopup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text("Add Company"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Company Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _codeController,
            decoration: const InputDecoration(
              labelText: "Company Code",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        if (_loading) const CircularProgressIndicator(),
        if (!_loading)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () async {
              String name = _nameController.text.trim();
              String code = _codeController.text.trim();

              if (name.isEmpty || code.isEmpty) {
                return;
              }

              setState(() => _loading = true);

              final workflow = Companynamepopupworkflow();
              final company = Companynamepopupmodel.create(
                companyName: name,
                companyCode: code.length >= 3 ? code : code + '1',
              );

              final created = await workflow.createCompany(company);

              try {
                final created = await workflow.createCompany(company);
                if (!mounted) return;
                Navigator.pop(context, created);
              } catch (e) {
                if (!mounted) return;
                Navigator.pop(context, null);
              } finally {
                if (mounted) setState(() => _loading = false);
              }
            },
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
      ],
    );
  }
}
