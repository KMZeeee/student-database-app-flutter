## Student Database Application Using Hive

[UI Reference](https://youtu.be/2VKpq4h3Sdw?si=w24qGcL0REZvCpIH) | [Hive Reference](https://youtu.be/xN_OTO5EYKY?si=qmnKE3A_-eDqBwXe) | [ChatGPT](https://chatgpt.com/)

### Programming Steps

Pada kesempatan kali ini saya akan menjelaskan secara singkat bagaimana cara saya dalam mengimplementasikan Hive sebagai local database.

#### Preparing Hive

Hal pertama yang harus dilakukan adalah menambahkan dependencies pada `pubspec.yaml` seperti dibawah ini.

- pubspec.yaml

```
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.0.14
  flutter_slidable: ^4.0.0
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1
  build_runner: ^2.4.6
```

Buat class (tabel) yang berisi atribut yang diinginkan. Disini saya membuat satu tabel bernama `Student` yang menyimpan data mahasiswa.

- student.dart

```
import 'package:hive/hive.dart';

part 'student.g.dart';

@HiveType(typeId: 0)
class Student extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int id;

  @HiveField(2)
  String major;

  Student({required this.name, required this.id, required this.major});
}

```

Generate adapter untuk class diatas untuk menyimpan data dalam format binary dengan command `flutter packages pub run build_runner build
`. Setelahnya akan menghasilkan file `student.g.dart` seperti dibawah ini.

- student.g.dart

```
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentAdapter extends TypeAdapter<Student> {
  @override
  final int typeId = 0;

  @override
  Student read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Student(
      name: fields[0] as String,
      id: fields[1] as int,
      major: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Student obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.major);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

```

#### Using Hive as Local Storage

Pada `main.dart` terdapat perbedaan ketike menggunakan database Hive.

- main.dart

```
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
```

Pada fungsi `main`, kita harus menginisialisasi hive dan me-register adapter dari class yang kita sudah buat sebelumnya. Tambahkan `async` karena program akan menunggu inisialisasi hive terlbih dahulu.

Pada widget build, gunakan `FutureBuilder` untuk menunggu proses asynchronus yaitu membuka `box` bernama `students` yang berisi data yang sudah berada sebelumnya pada database. `box` harus terbuka secara sempurna (selesai terlebih dahulu) sebelum menampilkan UI pertama. Jika tidak, akan menyebabkan error pada program.

---

Berikut adalah beberapa method dari `hive_flutter` package yang saya gunakan untuk implementasi CRUD pada program ini.

- saveData()

```
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
```

Untuk menambahkan data, kita hanya perlu mengakses `box` yang sudah kita buka sebelumnya pada `main.dart`. Cara mengaksesnnya menggunakan syntax `Hive.box<Student>('students')` dan di-assign dengan variabel `box`. Buat variabel `newStudent` untuk menampung input dari TextEditingController. Lalu untuk menambahkan data tersebut gunakan method add dengan syntax `box.add(newStudent)`.

- deleteData()

```
  void deleteData(int index) {
    final box = Hive.box<Student>('students');
    box.deleteAt(index);
    setState(() {});
  }
```

Menghapus data sangatlah mudah pada hive yaitu dengan method `deleteAt`. Disini saya menggunakan menggunakan `deleteAt` karena keperluan menghapus data beradasarkan index yang diinginkan.

- editData()

```
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
```

Untuk mengedit data yang sudah ada, kita perlu mengambil data berdasarkan indexnya dengan method `getAt`. Setelah menerima input, kita gunakan method `putAt` untuk menambahkan data yang sudah diganti pada index yang sama dengan data sebelumnya.

- menampilkan data

```
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
```

Terakhir, saya menggunakan `ValueListenableBuilder` karena widget ini akan me-refresh UI setelah ada perubahan pada `box`. Selanjutnya menggunakan `ListViewBuilder` dengan method `getAt` untuk menampilkan tiles yang berisi data mahasiswa. Jika `box` kosong (`box.isEmpty`) maka akan menampilkan `No students yet.`
