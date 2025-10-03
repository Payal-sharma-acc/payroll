import 'package:flutter/material.dart';
import 'dart:async';

class Employeetask extends StatefulWidget {
  @override
  _EmployeetaskState createState() => _EmployeetaskState();
}

class _EmployeetaskState extends State<Employeetask>
    with SingleTickerProviderStateMixin {
  List<String> tasks = [];
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTask() {
    setState(() {
      tasks.add("Task ${tasks.length + 1}");
    });
  }

  void _removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _clearAllTasks() {
    setState(() {
      tasks.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Tasks',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          if (tasks.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: _clearAllTasks,
              tooltip: 'Clear all tasks',
            ),
        ],
      ),
      body:
          tasks.isEmpty
              ? Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _animation.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'lib/assets/notask.gif',
                            width: 220,
                            height: 220,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 220,
                                height: 220,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 80, 
                                  color: Colors.grey[400],
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 20),
                          Text(
                            'No tasks yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add a task to get started',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
              : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Checkbox(
                      value: false,
                      onChanged: (bool? value) {},
                    ),
                    title: Text(tasks[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_outline),
                      onPressed: () => _removeTask(index),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
