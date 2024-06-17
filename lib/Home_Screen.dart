import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_assigner/TaskList_screem.dart';
import 'package:task_assigner/Widgets/text_field.dart';

import 'Widgets/spacing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference users = FirebaseFirestore.instance.collection('uid');

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController estimatedController = TextEditingController();

  late DateTime _dateTime;
  late TimeOfDay _deadlineTime;
  late TimeOfDay _estimatedTime;

  String completionStatus = "None";

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
    _deadlineTime = TimeOfDay.now();
    _estimatedTime = TimeOfDay.now();
    dateController.text =
        "${_dateTime.day}/${_dateTime.month}/${_dateTime.year}";
    updateDeadlineTimeController();
    updateEstimatedTimeController();
  }

  void updateDeadlineTimeController() {
    String period = _deadlineTime.period == DayPeriod.am ? 'AM' : 'PM';
    timeController.text =
        "${_deadlineTime.hourOfPeriod}:${_deadlineTime.minute} $period";
  }

  void updateEstimatedTimeController() {
    String period = _estimatedTime.period == DayPeriod.am ? 'AM' : 'PM';
    estimatedController.text =
        "${_estimatedTime.hourOfPeriod}:${_estimatedTime.minute} $period";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const TaskListScreen(), // Navigate to TaskListScreen
                    ),
                  );
                },
                icon: const Icon(Icons.access_time_rounded),
              ),
              IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
        ],
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        title: const Text(
          "Task Details",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mediumSpacing(context),
              const Text(
                "Task Title :",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              mediumSpacing(context),
              TextFieldInput(
                textEditingController: titleController,
                hintText: "Enter a Title",
                textInputType: TextInputType.text,
              ),
              largeSpacing(context),
              const Text(
                "Task Description :",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              mediumSpacing(context),
              TextFieldInput(
                textEditingController: descriptionController,
                hintText: "Enter a Detailed Description",
                textInputType: TextInputType.text,
                maxlines: 3,
              ),
              largeSpacing(context),
              const Text(
                "Task Deadline :",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              mediumSpacing(context),
              Row(
                children: [
                  Expanded(
                    child: TextFieldInputs(
                      readonly: true,
                      icon: Icons.calendar_today,
                      onIconTap: pickedDate,
                      textEditingController: dateController,
                      hintText:
                          "${_dateTime.day}/${_dateTime.month}/${_dateTime.year}",
                      textInputType: TextInputType.text,
                    ),
                  ),
                  Expanded(
                    child: TextFieldInputs(
                      icon: Icons.timer_sharp,
                      onIconTap: pickedDeadlineTime,
                      readonly: true,
                      textEditingController: timeController,
                      hintText: timeController.text,
                      textInputType: TextInputType.text,
                    ),
                  ),
                ],
              ),
              largeSpacing(context),
              const Text(
                "Task Estimated Time :",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              mediumSpacing(context),
              TextFieldInputs(
                readonly: true,
                icon: Icons.more_time,
                onIconTap: pickedEstimatedTime,
                textEditingController: estimatedController,
                hintText: estimatedController.text,
                textInputType: TextInputType.text,
              ),
              largeSpacing(context),
              const Text(
                "Completion Status",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              mediumSpacing(context),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("Completed"),
                      value: "Completed",
                      groupValue: completionStatus,
                      onChanged: (value) {
                        setState(() {
                          completionStatus = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("On Progress"),
                      value: "On Progress",
                      groupValue: completionStatus,
                      onChanged: (value) {
                        setState(() {
                          completionStatus = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              largeSpacing(context),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () async {
                    String? uid = FirebaseAuth.instance.currentUser?.uid;
                    if (uid != null) {
                      try {
                        var _firestore = FirebaseFirestore.instance;
                        var userDocRef =
                            _firestore.collection("users").doc(uid);
                        var tasksCollectionRef = userDocRef.collection('tasks');
                        await tasksCollectionRef.add({
                          'title': titleController.text,
                          'description': descriptionController.text,
                          'deadlineDate': dateController.text,
                          'deadlineTime': timeController.text,
                          'estimatedTime': estimatedController.text,
                          'completionStatus': completionStatus,
                        });

                        titleController.clear();
                        descriptionController.clear();
                        dateController.clear();
                        timeController.clear();
                        estimatedController.clear();
                        setState(() {
                          completionStatus = "None";
                        });
                      } catch (e) {
                        print("error>>>>>>>>$e");
                      }
                    }
                  },
                  child: const Text(
                    "Assign a Task",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  pickedDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (date != null) {
      setState(() {
        _dateTime = date;
        dateController.text =
            "${_dateTime.day}/${_dateTime.month}/${_dateTime.year}";
      });
    }
  }

  pickedDeadlineTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _deadlineTime,
    );
    if (time != null) {
      setState(() {
        _deadlineTime = time;
        updateDeadlineTimeController();
      });
    }
  }

  pickedEstimatedTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _estimatedTime,
    );
    if (time != null) {
      setState(() {
        _estimatedTime = time;
        updateEstimatedTimeController();
      });
    }
  }
}
