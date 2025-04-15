import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:student_database_app/models/student.dart';

class StudentTiles extends StatelessWidget {
  final Student student;
  final Function(BuildContext)? onDelete;
  final Function(BuildContext)? onEdit;

  const StudentTiles({
    super.key,
    required this.student,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 20.0,
        right: 20.0,
        bottom: 10.0,
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: onEdit,
              icon: Icons.edit,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.yellow,
              foregroundColor: Colors.black,
              autoClose: true,
            ),
            SlidableAction(
              onPressed: onDelete,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              autoClose: true,
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.person, size: 50.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      student.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    student.id.toString(),
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(student.major, style: const TextStyle(fontSize: 13)),
                ],
              ),
              Icon(Icons.arrow_back, size: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
