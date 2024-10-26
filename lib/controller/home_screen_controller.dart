import 'package:sqflite/sqflite.dart';

class HomeScreenController {
  static late Database myDatabase;
  static List<Map> employeeDataList = [];
  static Future initDb() async {
    // open the database
    myDatabase = await openDatabase("employeeData.db", version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db
          .execute('CREATE TABLE employee (id INTEGER PRIMARY KEY, note TEXT)');
    });
  }

  static Future addEmployee({
    required note,
  }) async {
    await myDatabase.rawInsert('INSERT INTO employee(note) VALUES(?)', [
      note,
    ]);
    getAllEmployee();
  }

  static Future getAllEmployee() async {
    employeeDataList = await myDatabase.rawQuery('SELECT * FROM employee');
    print(employeeDataList);
  }

  static Future removeEmployee(int id) async {
    await myDatabase.rawDelete('DELETE FROM employee WHERE id = ?', [id]);
    getAllEmployee();
  }

  static Future updateEmployee(String newNote, int id) async {
    await myDatabase
        .rawUpdate('UPDATE employee SET note = ? WHERE id = ?', [newNote, id]);
    getAllEmployee();
  }
}
