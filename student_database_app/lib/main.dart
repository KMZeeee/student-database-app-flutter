import 'package:flutter/material.dart';
import 'package:student_database_app/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_database_app/models/student.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(StudentAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox<Student>('students'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomePage(),
          );
        } else {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
      },
    );
  }
}
