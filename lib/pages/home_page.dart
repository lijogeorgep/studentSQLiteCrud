import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqlite/models/data_model.dart';
import 'package:flutter_sqlite/pages/add_edit_product.dart';
import 'package:flutter_sqlite/services/db_service.dart';
import 'package:flutter_sqlite/utils/form_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBService dbService;

  @override
  void initState() {
    super.initState();
    dbService = new DBService();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Student Details"),
      ),
      body: _fetchData(),
    );
  }

  Widget _fetchData() {
    return FutureBuilder<List<StudentModel>>(
      future: dbService.getStudents(),
      builder:
          (BuildContext context, AsyncSnapshot<List<StudentModel>> students) {
        if (students.hasData) {
          return _buildUI(students.data);
        }

        return CircularProgressIndicator();
      },
    );
  }

  Widget _buildUI(List<StudentModel> students) {
    List<Widget> widgets = new List<Widget>();

    widgets.add(
      new Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditStudent(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(

              color: Colors.black,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Add Student",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    widgets.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_buildDataTable(students)],
      ),
    );

    return Padding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
      padding: EdgeInsets.all(10),
    );
  }

  Widget _buildDataTable(List<StudentModel> model) {

    return DataTable(
      columns: [

        DataColumn(
          label: Text(
            "Name",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Age",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Mark",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Action",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      sortColumnIndex: 1,
      rows: model
          .map(
            (data) => DataRow(
              cells: <DataCell>[

                DataCell(
                  Text(
                    data.studentName,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                DataCell(
                  Text(
                    data.age.toString(),
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    data.mark.toString(),
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                DataCell(
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEditStudent(
                                  isEditMode: true,
                                  model: data,
                                ),
                              ),
                            );
                          },
                        ),
                        new IconButton(
                          padding: EdgeInsets.all(0),
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            FormHelper.showMessage(
                              context,
                              "Student",
                              "Do you want to delete this record?",
                              "Yes",
                              () {
                                dbService.deleteStudent(data).then((value) {
                                  setState(() {
                                    Navigator.of(context).pop();
                                  });
                                });
                              },
                              buttonText2: "No",
                              isConfirmationDialog: true,
                              onPressed2: () {
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
