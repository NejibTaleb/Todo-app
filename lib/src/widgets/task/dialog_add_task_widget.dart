import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/src/models/task.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DialogAddWidget extends StatefulWidget {
  const DialogAddWidget(
      {Key? key, required this.lastTaskId, required this.addTask})
      : super(key: key);

  final int lastTaskId;
  final Function addTask;

  @override
  _DialogAddWidgetState createState() => _DialogAddWidgetState();
}

class _DialogAddWidgetState extends State<DialogAddWidget> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _content = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Add new task'),
      content: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                validator: _validator,
                onChanged: (value) {
                  setState(() {
                    this._title = value;
                  });
                },
              ),
              TextFormField(
                minLines: 1,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Content',
                ),
                validator: _validator,
                onChanged: (value) {
                  setState(() {
                    this._content = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(child: Text('Add'), onPressed: _onPressAddButton)
      ],
    );
  }

  void _onPressAddButton() {

    if (_formKey.currentState!.validate()) {
      widget.addTask(
          new Task(widget.lastTaskId + 1, this._title, this._content, false, ""));
      CollectionReference Taskdb = FirebaseFirestore.instance.collection('TDB');
      Taskdb.add({'title':this._title,
        'content':this._content,
      'stat':false,
      'id':widget.lastTaskId+1})
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
      Navigator.pop(context);
    }
  }

  String? _validator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }
}
