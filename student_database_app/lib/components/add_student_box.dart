import 'package:flutter/material.dart';

class AddStudentBox extends StatelessWidget {
  final nameController;
  final idController;
  final majorController;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const AddStudentBox({
    super.key,
    required this.nameController,
    required this.idController,
    required this.majorController,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Data'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              hintText: 'Enter your name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: idController,
            decoration: const InputDecoration(
              labelText: 'ID',
              hintText: 'Enter your ID',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: majorController,
            decoration: const InputDecoration(
              labelText: 'Major',
              hintText: 'Enter your major',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialButton(
              onPressed: onSave,
              color: Colors.green,
              child: const Text('Save'),
            ),
            MaterialButton(
              onPressed: onCancel,
              color: Colors.red,
              child: const Text('Cancel'),
            ),
          ],
        ),
      ],
    );
  }
}
