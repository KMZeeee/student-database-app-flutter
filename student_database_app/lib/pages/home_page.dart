import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:student_database_app/components/add_student_box.dart';
import 'package:student_database_app/components/my_floating_action_button.dart';
import 'package:student_database_app/components/student_tiles.dart';
import 'package:student_database_app/models/student.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _majorController = TextEditingController();

  void addStudent() {
    showDialog(
      context: context,
      builder: (context) {
        return AddStudentBox(
          nameController: _nameController,
          idController: _idController,
          majorController: _majorController,
          onSave: saveData,
          onCancel: cancelData,
        );
      },
    );
  }

  void saveData() {
    final box = Hive.box<Student>('students');

    final newStudent = Student(
      name: _nameController.text,
      id: int.parse(_idController.text),
      major: _majorController.text,
    );

    box.add(newStudent);

    _nameController.clear();
    _idController.clear();
    _majorController.clear();

    Navigator.pop(context);
    setState(() {});
  }

  void cancelData() {
    _nameController.clear();
    _idController.clear();
    _majorController.clear();
    Navigator.pop(context);
  }

  void deleteData(int index) {
    final box = Hive.box<Student>('students');
    box.deleteAt(index);
    setState(() {});
  }

  void editData(int index) {
    final box = Hive.box<Student>('students');
    final student = box.getAt(index)!;

    _nameController.text = student.name;
    _idController.text = student.id.toString();
    _majorController.text = student.major;

    showDialog(
      context: context,
      builder: (context) {
        return AddStudentBox(
          nameController: _nameController,
          idController: _idController,
          majorController: _majorController,
          onSave: () {
            final updatedStudent = Student(
              name: _nameController.text,
              id: int.parse(_idController.text),
              major: _majorController.text,
            );

            box.putAt(index, updatedStudent);

            _nameController.clear();
            _idController.clear();
            _majorController.clear();

            Navigator.pop(context);

            setState(() {});
          },
          onCancel: cancelData,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Database')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Student>('students').listenable(),
        builder: (context, Box<Student> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("No students yet."));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final student = box.getAt(index)!;

              return StudentTiles(
                student: student,
                onDelete: (context) => deleteData(index),
                onEdit: (context) => editData(index),
              );
            },
          );
        },
      ),
      floatingActionButton: MyFloatingActionButton(onPressed: addStudent),
    );
  }
}
