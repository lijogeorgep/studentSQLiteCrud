import 'package:flutter_sqlite/models/model.dart';

class StudentModel extends Model {
  static String table = 'student';

  int id;
  String studentName;
  int age;
  int mark;
  String studentPic;

  StudentModel({
    this.id,
    this.studentName,
    this.age,
    this.mark,
    this.studentPic,
  });

  static StudentModel fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map["id"],
      studentName: map['studentName'].toString(),
      age: map['age'],
      mark: map['mark'],
      studentPic: map['studentPic'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'id': id,
      'studentName': studentName,
      'age': age,
      'mark': mark,
      'studentPic': studentPic
    };

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
