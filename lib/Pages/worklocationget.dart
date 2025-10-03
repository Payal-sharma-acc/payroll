import 'package:flutter/material.dart';
import 'package:payrollapp/Models/updateworklocationmodel.dart';

import 'package:payrollapp/Models/worklocationgetmodel.dart';
import 'package:payrollapp/Pages/worklocation.dart';
import 'package:payrollapp/Workflows/worklocationgetworkflow.dart';
import 'package:payrollapp/Workflows/deleteworklocationworkflow.dart';

class Worklocationget extends StatefulWidget {
  const Worklocationget({super.key});

  @override
  State<Worklocationget> createState() => _WorkLocationGetState();
}

class _WorkLocationGetState extends State<Worklocationget> {
  List<Worklocationgetmodel> _locations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final workflow = Worklocationgetworkflow();
    final result = await Worklocationgetworkflow.getWorkLocations();
    setState(() {
      _locations = result;
      _isLoading = false;
    });
  }

  Future<void> _onDeleteLocation(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Location'),
        content: const Text('Are you sure you want to delete this location?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final deleteWorkflow = DeleteWorkLocationWorkflow();
      final success = await deleteWorkflow.deleteWorkLocation(id);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Location deleted successfully')),
        );
        _loadLocations(); // Refresh after delete
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Failed to delete location')),
        );
      }
    }
  }

  void _onUpdateLocation(updateworklocationmodel location) {
    // Uncomment and implement this if you want update navigation
    /*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateWorkLocation(existingLocation: location),
      ),
    ).then((_) => _loadLocations());
    */
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("Work Locations")),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: _locations.length,
                  itemBuilder: (context, index) {
                    final loc = _locations[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loc.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Id: ${loc.id}'),
                                  Text(loc.addressLine1),
                                  Text(loc.addressLine2),
                                  Text('${loc.city}, ${loc.state} - ${loc.pinCode}'),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'update') {
                                  _onUpdateLocation(updateworklocationmodel(
                                    id: loc.id,
                                    name: loc.name,
                                    addressLine1: loc.addressLine1,
                                    addressLine2: loc.addressLine2,
                                    city: loc.city,
                                    state: loc.state,
                                    pinCode: loc.pinCode,
                                  ));
                                } else if (value == 'delete') {
                                  _onDeleteLocation(int.parse(loc.id));
                                }
                              },
                              itemBuilder: (context) => [
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
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Worklocation(),
                        ),
                      ).then((_) => _loadLocations());
                    },
                    child: const Text(
                      'Add Work Location',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
  );
}
}