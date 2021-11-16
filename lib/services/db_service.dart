import 'package:flutter_sqlite/models/data_model.dart';
import 'package:flutter_sqlite/utils/db_helper.dart';

class DBService {
  Future<bool> addStudent(StudentModel model) async {
    await DB.init();
    bool isSaved = false;
    if (model != null) {
      int inserted = await DB.insert(StudentModel.table, model);

      isSaved = inserted == 1 ? true : false;
    }

    return isSaved;
  }

  Future<bool> updateStudent(StudentModel model) async {
    await DB.init();
    bool isUpdated = false;
    if (model != null) {
      int updated = await DB.update(StudentModel.table, model);

      isUpdated = updated == 1 ? true : false;
    }

    return isUpdated;
  }

  Future<List<StudentModel>> getStudents() async {
    await DB.init();
    List<Map<String, dynamic>> students = await DB.query(StudentModel.table);

    return students.map((item) => StudentModel.fromMap(item)).toList();
  }


  Future<bool> deleteStudent(StudentModel model) async {
    await DB.init();
    bool isDeleted = false;
    if (model != null) {
      int deleted = await DB.delete(StudentModel.table, model);

      isDeleted = deleted == 1 ? true : false;
    }

    return isDeleted;
  }
}
