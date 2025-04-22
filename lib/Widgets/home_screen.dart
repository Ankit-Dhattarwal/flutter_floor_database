import 'package:floor_database_flutter/Entity/student_entity.dart';
import 'package:floor_database_flutter/database/app_database.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<AppDatabase> _dbFuture;

  @override
  void initState() {
    super.initState();
    _dbFuture = AppDatabase.init(); // Initialize database when screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Database')),
      body: FutureBuilder<AppDatabase>(
      future: _dbFuture,
      builder: (context, dbSnapshot) {
        if (dbSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (dbSnapshot.hasError) {
          return Center(child: Text('Error: ${dbSnapshot.error}'));
        }

        final db = dbSnapshot.data!;

        return StreamBuilder<List<Student>>(
          stream: db.studentDao.streamAllStudents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Stream Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No students yet! Tap the + button to add one.',
                  textAlign: TextAlign.center,
                ),
              );
            }

            final students = snapshot.data!;
            return ListView.separated(
              itemCount: students.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final student = students[index];
                return ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text(student.name),
                  subtitle: Text('Age: ${student.age}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await db.studentDao.deleteStudentById(student.id!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${student.name} deleted')),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    ),
    floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        tooltip: 'Add Student',
        child: const Icon(Icons.add),
      ),
    );
  }


  // Show a dialog to add a new student
  void _showAddDialog() {
    final nameController = TextEditingController();
    final ageController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) =>
          AlertDialog(
            title: const Text('Add New Student'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter student name',
                  ),
                  textCapitalization: TextCapitalization.words,
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    hintText: 'Enter student age',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  // Validate input
                  if (nameController.text.isEmpty ||
                      ageController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all fields')),
                    );
                    return;
                  }

                  int? age = int.tryParse(ageController.text);
                  if (age == null || age <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid age')),
                    );
                    return;
                  }

                  // Save the student to the database
                  final db = await _dbFuture;
                  await db.studentDao.insertStudent(
                    Student(
                      id: null, // database assign an ID
                      name: nameController.text.trim(),
                      age: age,
                    ),
                  );

                  if (mounted) {
                    Navigator.pop(context);
                    // UI updates automatically thanks to StreamBuilder!
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }
}