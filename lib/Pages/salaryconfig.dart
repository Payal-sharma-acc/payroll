import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payrollapp/Models/salaryconfiggetmodel.dart';
import 'package:payrollapp/Models/salaryconfigmodel.dart';
import 'package:payrollapp/Workflows/salaryconfigupdateworkflow.dart';
import 'package:payrollapp/Workflows/salaryconfigworkflow.dart';
import 'package:payrollapp/Workflows/salaryconfiggetworkflow.dart';
import 'package:payrollapp/Workflows/salaryconfigdeleteworkflow.dart';

class SalaryConfig extends StatefulWidget {
  final int orgId;
  const SalaryConfig({super.key, required this.orgId});

  @override
  State<SalaryConfig> createState() => _SalaryConfigState();
}

class _SalaryConfigState extends State<SalaryConfig> {
  final _formKey = GlobalKey<FormState>();
  String? selectedComponent;
  String? selectedType;
  final TextEditingController fixedAmountController = TextEditingController();
  bool isActive = true;

  List<String> components = [
    'BasicSalary',
    'HRA',
    'Conveyance allowance',
    'Fixed Allowance',
    'Bonus',
    'Arrears',
    'Overtime Hours',
    'Overtime Rate',
    'Leave Encashment',
    'Special Allowance',
    'PF Employee',
    'ESIC Employee',
    'Profesional Tax',
    'TDS',
    'Loan Repayment',
    'Other Deductions',
    'Basic',
  ];

  List<String> types = ['Fixed', 'Percentage'];
  List<Salaryconfiggetmodel> configList = [];
  int? editingIndex;

  @override
  void initState() {
    super.initState();
    fetchConfigs();
  }

  Future<void> fetchConfigs() async {
    try {
      final data = await SalaryConfiggetWorkflow().getConfigByOrg(widget.orgId);
      setState(() {
        configList = data;
      });
    } catch (e) {
      print("Error fetching configs: $e");
    }
  }

  Future<void> _saveComponent() async {
    if (!_formKey.currentState!.validate()) return;

   final model = Salaryconfigmodel(
  orgId: widget.orgId,
  componentName: selectedComponent!,
  isEnabled: isActive,
  calculationType: selectedType == 'Fixed' ? 1 : 2,
  fixedAmount: selectedType == 'Fixed' 
      ? double.tryParse(fixedAmountController.text)
      : null, 
  percentageValue: selectedType == 'Percentage'
      ? double.tryParse(fixedAmountController.text)
      : null, 
);

    try {
      if (editingIndex == null) {
        await Salaryconfigworkflow().saveComponentConfig([model]);
      } else {
        final existing = configList[editingIndex!];
        final updatedModel = Salaryconfigmodel(
          componentConfigId: existing.componentConfigId,
          orgId: widget.orgId,
          componentName: selectedComponent!,
          isEnabled: isActive,
          calculationType: selectedType == 'Fixed' ? 1 : 2,
          fixedAmount:
              selectedType == 'Fixed'
                  ? double.tryParse(fixedAmountController.text)
                  : 0,
          percentageValue:
              selectedType == 'Percentage'
                  ? double.tryParse(fixedAmountController.text)
                  : 0,
        );

        await Salaryconfigupdateworkflow().updateConfig(updatedModel);
      }

      await fetchConfigs();
      _formKey.currentState!.reset();
      fixedAmountController.clear();
      setState(() {
        selectedComponent = null;
        selectedType = null;
        isActive = true;
        editingIndex = null;
      });
    } catch (e) {
      print("Error saving/updating component: $e");
    }
  }

  void _prefillForm(Salaryconfiggetmodel item, int index) {
    setState(() {
      selectedComponent = item.componentName;
      selectedType = item.calculationType == 1 ? 'Fixed' : 'Percentage';
      fixedAmountController.text =
          item.calculationType == 1
              ? (item.fixedAmount?.toString() ?? '')
              : (item.percentageValue?.toString() ?? '');
      isActive = item.isEnabled ?? true;
      editingIndex = index;
    });
  }

  void _cancelEdit() {
    setState(() {
      selectedComponent = null;
      selectedType = null;
      fixedAmountController.clear();
      isActive = true;
      editingIndex = null;
      _formKey.currentState?.reset();
    });
  }

  @override
  void dispose() {
    fixedAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFFFFF),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color.fromARGB(255, 218, 250, 253)],
            stops: [0.3, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 5),
                  const Expanded(
                    child: Text(
                      'Salary Configuration',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Active"),
                  Switch(
                    value: isActive,
                    onChanged: (val) => setState(() => isActive = val),
                    activeColor: Colors.blue,
                    activeTrackColor: Colors.blue.shade200,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey.shade400,
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Component Name *',
                      ),
                      value: selectedComponent,
                      items:
                          components
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged:
                          (val) => setState(() => selectedComponent = val),
                      validator: (val) => val == null ? 'Required' : null,
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Calculation Type *',
                      ),
                      value: selectedType,
                      items:
                          types
                              .map(
                                (e) =>
                                    DropdownMenuItem(value: e, child: Text(e)),
                              )
                              .toList(),
                      onChanged: (val) => setState(() => selectedType = val),
                      validator: (val) => val == null ? 'Required' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: fixedAmountController,
                      decoration: InputDecoration(
                        labelText:
                            selectedType == 'Percentage'
                                ? 'Percentage % '
                                : 'Fixed Amount ',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d{0,6}(\.\d{0,2})?$'),
                        ),
                      ],
                      validator: (val) {
                        if (val == null || val.isEmpty) return 'Required';
                        final value = double.tryParse(val);
                        if (value == null) return 'Enter a valid number';
                        if (value > 999999.99) return 'Amount too large';
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveComponent,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              editingIndex == null
                                  ? "Add Component"
                                  : "Update Component",
                            ),
                          ),
                        ),
                        if (editingIndex != null) ...[
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _cancelEdit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child:
                    configList.isEmpty
                        ? const Center(child: Text("No data found."))
                        : ListView.builder(
                          itemCount: configList.length,
                          itemBuilder: (context, index) {
                            if (editingIndex != null && editingIndex != index) {
                              return const SizedBox.shrink();
                            }
                            final item = configList[index];
                            return Card(
                              elevation: 2,

                              child: ListTile(
                                title: Text(
                                  "Component Name : ${item.componentName ?? ''}",
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Calculation Type : ${item.calculationType == 1 ? 'Fixed' : 'Percentage'}",
                                    ),
                                    Text(
                                      "Value : ${item.calculationType == 1 ? '${item.fixedAmount}' : '${item.percentageValue}%'}",
                                    ),
                                    Text(
                                      "Status : ${item.isEnabled == true ? 'Active' : 'Inactive'}",
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'Edit') {
                                      _prefillForm(item, index);
                                    } else if (value == 'Delete') {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              title: const Text(
                                                "Confirm Deletion",
                                              ),
                                              content: const Text(
                                                "Are you sure you want to delete this component?",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.of(
                                                        context,
                                                      ).pop(false),
                                                  child: const Text("Cancel"),
                                                ),
                                                ElevatedButton(
                                                  onPressed:
                                                      () => Navigator.of(
                                                        context,
                                                      ).pop(true),
                                                  child: const Text("Delete"),
                                                ),
                                              ],
                                            ),
                                      );

                                      if (confirm == true) {
                                        final success =
                                            await SalaryConfigDeleteWorkflow()
                                                .deleteComponentById(
                                                  item.componentConfigId!,
                                                );
                                        if (success == true) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Component deleted successfully",
                                              ),
                                            ),
                                          );
                                          await fetchConfigs();
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Failed to delete component",
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  },
                                  itemBuilder:
                                      (context) => const [
                                        PopupMenuItem(
                                          value: 'Edit',
                                          child: Text('Edit'),
                                        ),
                                        PopupMenuItem(
                                          value: 'Delete',
                                          child: Text('Delete'),
                                        ),
                                      ],
                                  icon: const Icon(Icons.more_vert),
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
