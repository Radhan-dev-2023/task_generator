import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_assigner/Widgets/text_field.dart';

import 'Widgets/spacing.dart';

class TaskEditScreen extends StatefulWidget {
  final String taskId;
  final Map<String, dynamic> taskData;

  TaskEditScreen({required this.taskId, required this.taskData});

  @override
  _TaskEditScreenState createState() => _TaskEditScreenState();
}

class _TaskEditScreenState extends State<TaskEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _estimatedController;
  late String _completionStatus;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.taskData['title']);
    _descriptionController = TextEditingController(text: widget.taskData['description']);
    _dateController = TextEditingController(text: widget.taskData['deadlineDate']);
    _timeController = TextEditingController(text: widget.taskData['deadlineTime']);
    _estimatedController = TextEditingController(text: widget.taskData['estimatedTime']);
    _completionStatus = widget.taskData['completionStatus'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
        title: Text(
          'Edit Task',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                mediumSpacing(context),
                customTextFields(_titleController, 'Title'),
                largeSpacing(context),
                customTextFields(_descriptionController, 'Description', maxlines: 3),
                largeSpacing(context),
                customTextFields(_dateController, 'Deadline Date'),
                largeSpacing(context),
                customTextFields(_timeController, 'Deadline Time'),
                largeSpacing(context),
                customTextFields(_estimatedController, 'Estimated Time'),
                largeSpacing(context),
                _buildCompletionStatusRadioButtons(),
                mediumSpacing(context),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      _saveChanges();
                      Navigator.pop(context);
                    },
                    child: Text(
                      "SAVE",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionStatusRadioButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Completion Status',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      /*  RadioListTile<String>(
          title: Text('Not Started'),
          value: 'Not Started',
          groupValue: _completionStatus,
          onChanged: (value) {
            setState(() {
              _completionStatus = value!;
            });
          },
        ),*/
        RadioListTile<String>(
          title: Text('On Progress'),
          value: 'On Progress',
          groupValue: _completionStatus,
          onChanged: (value) {
            setState(() {
              _completionStatus = value!;
            });
          },
        ),
        RadioListTile<String>(
          title: Text('Completed'),
          value: 'Completed',
          groupValue: _completionStatus,
          onChanged: (value) {
            setState(() {
              _completionStatus = value!;
            });
          },
        ),
      ],
    );
  }

  void _saveChanges() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        var _firestore = FirebaseFirestore.instance;
        var userDocRef = _firestore.collection("users").doc(uid);
        var tasksCollectionRef = userDocRef.collection('tasks');

        await tasksCollectionRef.doc(widget.taskId).update({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'deadlineDate': _dateController.text,
          'deadlineTime': _timeController.text,
          'estimatedTime': _estimatedController.text,
          'completionStatus': _completionStatus,
        });

        // Show success message or perform any other actions
      }
    } catch (e) {
      print("Error updating task: $e");
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _estimatedController.dispose();
    super.dispose();
  }
}
