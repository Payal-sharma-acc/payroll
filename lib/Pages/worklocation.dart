import 'package:flutter/material.dart';
import 'package:payrollapp/Models/worklocationmodel.dart';
import 'package:payrollapp/Pages/worklocationget.dart';
import 'package:payrollapp/Workflows/worklocationworkflow.dart';

class Worklocation extends StatefulWidget {
  final Worklocationmodel? existingLocation;

  const Worklocation({super.key, this.existingLocation});

  @override
  State<Worklocation> createState() => _WorkLocationPostPageState();
}

class _WorkLocationPostPageState extends State<Worklocation> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();

  bool _isSubmitting = false;
  String? _selectedState;

  final List<String> _states = [
    "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh",
    "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand", "Karnataka",
    "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya",
    "Mizoram", "Nagaland", "Odisha", "Punjab", "Rajasthan", "Sikkim",
    "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand",
    "West Bengal", "Delhi"
  ];

  @override
  void initState() {
    super.initState();
    if (widget.existingLocation != null) {
      _nameController.text = widget.existingLocation!.name;
      _address1Controller.text = widget.existingLocation!.addressLine1;
      _address2Controller.text = widget.existingLocation!.addressLine2;
      _stateController.text = widget.existingLocation!.state;
      _cityController.text = widget.existingLocation!.city;
      _pinCodeController.text = widget.existingLocation!.pinCode;
      _selectedState = widget.existingLocation!.state;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      final location = Worklocationmodel(
        name: _nameController.text,
        addressLine1: _address1Controller.text,
        addressLine2: _address2Controller.text,
        state: _selectedState ?? '',
        city: _cityController.text,
        pinCode: _pinCodeController.text,
      );

      final workflow = WorkLocationWorkflow();
      bool success = false;

      if (widget.existingLocation == null) {
        success = await workflow.saveWorkLocation(location);
      } else {
        success = await workflow.updateWorkLocation(location);
      }

      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.existingLocation == null
                ? ' Work location created'
                : ' Work location updated'),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Worklocationget()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Operation failed')),
        );
      }
    }
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Required' : null,
        keyboardType: keyboardType,
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: _selectedState,
        isExpanded: true,
        items: _states.map((state) {
          return DropdownMenuItem<String>(
            value: state,
            child: Text(state),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedState = value;
          });
        },
        decoration: const InputDecoration(
          labelText: 'State',
          border: OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }

  Widget _buildImportExportRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: Colors.blue.shade50,
              child: InkWell(
                onTap: () {
                 
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: const [
                      Icon(Icons.download, color: Colors.blue),
                      SizedBox(height: 8),
                      Text('Import'),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Card(
              color: Colors.green.shade50,
              child: InkWell(
                onTap: () {
           
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: const [
                      Icon(Icons.upload, color: Colors.green),
                      SizedBox(height: 8),
                      Text('Export'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Work Location')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildImportExportRow(),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildTextField(_nameController, 'Work Location Name'),
                    const SizedBox(height: 16),
                    const Text('Address *', style: TextStyle(fontWeight: FontWeight.bold)),
                    _buildTextField(_address1Controller, 'Address Line 1'),
                    _buildTextField(_address2Controller, 'Address Line 2'),
                    _buildDropdown(),
                    _buildTextField(_cityController, 'City'),
                    _buildTextField(_pinCodeController, 'Pin Code', keyboardType: TextInputType.number),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16)),
                            child: _isSubmitting
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('Save'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16)),
                            child: const Text('Cancel'),
                          ),
                        ),
                      ],
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
