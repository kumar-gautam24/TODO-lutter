// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/components/button.dart';
import 'package:todo/components/todotiles.dart';
import 'package:todo/database/database.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // reference the hive box
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // first open create database
    db.loadData();
    super.initState();
  }

  // List db.toDoList = [];
// check box bool
  void checkBox(bool? p0, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  // text controller
  final myController = TextEditingController();

// save function
  void onSave() {
    if (myController.text.isNotEmpty) {
      setState(() {
        db.toDoList.add([
          myController.text,
          false,
          myController.clear(),
        ]);
      });
    }
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  // cancel function
  void onCancel() {
    Navigator.of(context).pop();
  }

// create new task
  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.brown.shade300,
          // ignore: sized_box_for_whitespace
          content: Container(
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: myController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Add new task",
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // save button
                    MyButton(
                      text: "Save",
                      onPressed: onSave,
                    ),
                    // cancel button
                    MyButton(
                      text: "Cancel",
                      onPressed: onCancel,
                    )
                  ],
                )
              ],
              // buttons
            ),
          ),
        );
      },
    );
  }

// delete task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: const Text(
          'TO DO',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(
          Icons.add,
        ),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: ((context, index) {
          return ToDoTile(
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (p0) => checkBox(p0, index),
            deleteTapped: (p1) => deleteTask(index),
          );
        }),
      ),
    );
  }
}
