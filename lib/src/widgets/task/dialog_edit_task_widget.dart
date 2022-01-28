import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/src/models/task.dart';
import 'package:todo_app/src/views/home.dart';



class DialogEditWidget extends StatefulWidget {
  const DialogEditWidget({Key? key, required this.task, required this.editTask})
      : super(key: key);
  final Task task;
  final Function editTask;


  @override
  _DialogEditWidgetState createState() => _DialogEditWidgetState();
}

class _DialogEditWidgetState extends State<DialogEditWidget> {
  final _formKey = GlobalKey<FormState>();
  final Stream<QuerySnapshot> Taskdb = FirebaseFirestore.instance.collection('Taskdb').snapshots();
  String _title = '';
  String _content = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Edit task ${widget.task.title}'),
      content: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                initialValue: widget.task.title,
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
                initialValue: widget.task.content,
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
        IconButton(
          color: Theme.of(context).accentColor,
          onPressed: _onDeleteButton,
          icon: Icon(Icons.delete)),
        TextButton(
          onPressed: () => Navigator.pop(context),

          child: Text('Cancel'),
        ),
        ElevatedButton(child: Text('Save'), onPressed: _onPressedSaveButton),

      ],
    );
  }

  void _onPressedSaveButton() {
    if (_formKey.currentState!.validate()) {
      widget.editTask(
          new Task(widget.task.id, _title, _content, widget.task.isCompleted, widget.task.fbid));
      CollectionReference Taskdb = FirebaseFirestore.instance.collection('TDB');
      Taskdb.doc(widget.task.fbid).update({'title':_title,'content':_content});

      Navigator.pop(context);
    }
  }

  void _onDeleteButton() {
    widget.editTask(
        new Task(widget.task.id, _title, _content, widget.task.isCompleted, widget.task.fbid));
    CollectionReference Taskdb = FirebaseFirestore.instance.collection('TDB');
    Taskdb.doc(widget.task.fbid).delete();
        }


  String? _validator(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  }
}
