import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/src/models/task.dart';
import 'package:todo_app/src/widgets/task/dialog_add_task_widget.dart';
import 'package:todo_app/src/widgets/task/task_widget.dart';
import 'package:todo_app/src/__mocks__/tasks_mock.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> Taskdb = FirebaseFirestore.instance.collection('TDB').snapshots();

  List<Task> _tasks = tasksMock;



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Taskdb,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            final data = snapshot.requireData;

            return ListView.builder(
              itemCount: data.size,
              itemBuilder: (BuildContext context,index) {
                Task T=new Task(data.docs[index]['id'],data.docs[index]['title'],data.docs[index]['content'],data.docs[index]['stat'],"");
                T.fbid =data.docs[index].id;               // return SizedBox();
                return TaskWidget(

                  key: Key(data.docs[index]['id'].toString()),
                  index: index,
                  task: T,
                  toggleCompleteTask: _toggleCompleteTask,
                  removeTask: _removeTask,
                  undoRemoveTask: _undoRemoveTask,
                  editTask: _editTask,
                );

              },);
          }),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        focusColor: Theme.of(context).accentColor,
        hoverColor: Theme.of(context).accentColor,
        onPressed: _onPressedAddButton,
        child: Icon(CupertinoIcons.add),
      ),
    );
  }

  void _onPressedAddButton() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogAddWidget(
              lastTaskId: _getLastTaskId(), addTask: _addTask);
        });
  }

  int _getLastTaskId() {
    if (this._tasks.isEmpty) {
      return 0;
    }
    return this
        ._tasks
        .reduce((curr, next) => curr.id > next.id ? curr : next)
        .id;
  }

  void _addTask(Task task) {
    setState(() {
      this._tasks.add(task);
    });
  }

  void _toggleCompleteTask(int taskId) {
    setState(() {
      this._tasks = this._tasks.map((task) {
        if (task.id != taskId) {
          return task;
        } else {
          return new Task(task.id, task.title, task.content, !task.isCompleted,"");
        }
      }).toList();
    });
  }

  void _removeTask(int taskId) {
    setState(() {
      this._tasks = this._tasks.where((task) => task.id != taskId).toList();
    });
  }

  void _undoRemoveTask(int index, Task task) {
    setState(() {
      this._tasks.insert(index, task);
    });
  }

  void _editTask(Task task) {
    setState(() {
      this._tasks = this._tasks.map((item) {
        if (item.id == task.id) {
          return task;
        }
        return item;
      }).toList();
    });
  }
}
