
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqlite/models/data_model.dart';
import 'package:flutter_sqlite/pages/home_page.dart';
import 'package:flutter_sqlite/services/db_service.dart';
import 'package:flutter_sqlite/utils/form_helper.dart';

class AddEditStudent extends StatefulWidget {
  AddEditStudent({Key key, this.model, this.isEditMode = false})
      : super(key: key);
  StudentModel model;
  bool isEditMode;

  @override
  _AddEditStudentState createState() => _AddEditStudentState();
}

class _AddEditStudentState extends State<AddEditStudent> {
  StudentModel model;
  DBService dbService;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbService = new DBService();
    model = new StudentModel();

    if (widget.isEditMode) {
      model = widget.model;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        title: Text(widget.isEditMode ? "Edit Student" : "Add Student"),
      ),
      body: new Form(
        key: globalFormKey,
        child: _formUI(),
      ),
    );
  }

  Widget _formUI() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormHelper.fieldLabel("Student Name"),
                FormHelper.textInput(
                  context,
                  model.studentName,
                  (value) => {
                    this.model.studentName = value,
                  },
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Please enter student Name.';
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("student age"),
                FormHelper.textInput(
                  context,
                  model.age,
                  (value) => {
                    this.model.age = int.parse(value),
                  },
                  isNumberInput: true,
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Please enter age.';
                    }

                    if (value.toString().isNotEmpty &&
                        double.parse(value.toString()) <= 0) {
                      return 'Please enter valid age.';
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("student mark"),
                FormHelper.textInput(
                  context,
                  model.mark,
                      (value) => {
                    this.model.mark = int.parse(value),
                  },
                  isNumberInput: true,
                  onValidate: (value) {
                    if (value.toString().isEmpty) {
                      return 'Please enter mark.';
                    }

                    if (value.toString().isNotEmpty &&
                        double.parse(value.toString()) <= 0) {
                      return 'Please enter valid mark.';
                    }
                    return null;
                  },
                ),
                FormHelper.fieldLabel("Select student Photo"),
                FormHelper.picPicker(
                  model.studentPic,
                  (file) => {
                    setState(
                      () {
                        model.studentPic = file.path;
                      },
                    )
                  },
                ),
                btnSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }



  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget btnSubmit() {
    return new Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          if (validateAndSave()) {
            print(model.toMap());
            if (widget.isEditMode) {
              dbService.updateStudent(model).then((value) {
                FormHelper.showMessage(
                  context,
                  "Student",
                  "Data Submitted Successfully",
                  "Ok",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                );
              });
            } else {
              dbService.addStudent(model).then((value) {
               FormHelper.showMessage(
                  context,
                  "Student",
                  "Data Modified Successfully",
                  "Ok",
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                );
              });
            }
          }
        },
        child: Container(
          height: 40.0,
          margin: EdgeInsets.all(10),
          width: 100,
          color: Colors.black,
          child: Center(
            child: Text(
              "Save Details",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
