import 'package:flutter/material.dart';
import 'package:payrollapp/Workflows/permisiongetworkflow.dart';
import 'package:payrollapp/Models/permissiongetmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Permissiongetdata extends StatefulWidget {
  final int adminUserId;

  const Permissiongetdata({Key? key, required this.adminUserId})
    : super(key: key);

  @override
  _PermissiongetdataState createState() => _PermissiongetdataState();
}

class _PermissiongetdataState extends State<Permissiongetdata> {
  late Future<List<Permissiongetmodel>> _permissionsFuture;

  @override
  void initState() {
    super.initState();
    _loadPermissions();
  }

  Future<void> _loadPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';

    setState(() {
      _permissionsFuture = Permissiongetworkflow().getPermissionsByAdminId(
        widget.adminUserId,
        token,
      ); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Permissions')),

      body: FutureBuilder<List<Permissiongetmodel>>(
        future: _permissionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No permissions found."));
          }

          final permissions = snapshot.data!;
          return ListView.builder(
            itemCount: permissions.length,
            itemBuilder: (context, index) {
              final p = permissions[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(p.moduleName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('View: ${p.canView}'),
                      Text('Create: ${p.canCreate}'),
                      Text('Edit: ${p.canEdit}'),
                      Text('Delete: ${p.canDelete}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
