import 'package:sqflite/sqflite.dart';

class HomeScreenController {
  static late Database myDatabase;
  static List<Map> employeeDataList = [];

  static Future initDb() async {
    // Open the database
    myDatabase = await openDatabase("employeeData1.db", version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table with a timestamp field
      await db.execute('''
        CREATE TABLE employee (
          id INTEGER PRIMARY KEY, 
          note TEXT, 
          timestamp TEXT
        )
      ''');
    });
  }

  // Method to add a new employee (note) with the current timestamp
  static Future addEmployee(
      {required String note, required String timestamp}) async {
    String timestamp =
        DateTime.now().toUtc().toString(); // Get the current timestamp
    await myDatabase
        .rawInsert('INSERT INTO employee(note, timestamp) VALUES(?, ?)', [
      note,
      timestamp,
    ]);
    getAllEmployee();
  }

  // Method to fetch all employees (notes) with timestamps
  static Future getAllEmployee() async {
    employeeDataList = await myDatabase.rawQuery('SELECT * FROM employee');
    print(employeeDataList); // For debugging purposes
  }

  // Method to remove an employee (note)
  static Future removeEmployee(int id) async {
    await myDatabase.rawDelete('DELETE FROM employee WHERE id = ?', [id]);
    getAllEmployee();
  }

  // Method to update an employee's (note's) content and update the timestamp
  static Future updateEmployee(String newNote, int id) async {
    String timestamp =
        DateTime.now().toUtc().toString(); // Get the current timestamp
    await myDatabase.rawUpdate(
        'UPDATE employee SET note = ?, timestamp = ? WHERE id = ?',
        [newNote, timestamp, id]);
    getAllEmployee();
  }
}
