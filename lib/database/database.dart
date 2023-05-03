import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase {
  final _myBox = Hive.box('mybox');
  List toDoList = [];
  void loadData() {
    toDoList = _myBox.get("TODOLIST");
  }

  // update the database
  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }
}
