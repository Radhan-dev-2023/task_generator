import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_assigner/Widgets/snackbar.dart';
import 'package:task_assigner/Widgets/text_field.dart';
import 'package:task_assigner/Widgets/text_styles.dart';
import 'package:task_assigner/widgets/alert_dialog.dart';
import 'package:task_assigner/widgets/navigation.dart';
import '../Widgets/spacing.dart';
import '../constants/colors.dart';
import '../main.dart';
import 'login_screen.dart';
import 'tasklist_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  navigatesToScreen(context, const TaskListScreen());
                },
                icon: const Icon(
                  Icons.view_list,
                  color: white,
                ),
              ),
              IconButton(
                onPressed: () async {
                  try {
                    FirebaseAuth.instance.signOut();
                    showMyDialog(context);
                  } catch (e) {
                    print("Error signing out: $e");
                    showSnackBar(context, "Failed to sign out");
                  }
                },
                icon: const Icon(
                  Icons.logout,
                  color: white,
                ),
              ),
            ],
          ),
        ],
        backgroundColor: blue,
        title: const Text(
          "Task Details",
          style: TextStyle(color: white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mediumSpacing(context),
              Text(
                "Task Title :",
                style: boldTextStyle,
              ),
              mediumSpacing(context),
              TextFieldInput(
                textEditingController: titleController,
                hintText: "Enter a Title",
                textInputType: TextInputType.text,
              ),
              largeSpacing(context),
              Text(
                "Task Description :",
                style: boldTextStyle,
              ),
              mediumSpacing(context),
              TextFieldInput(
                textEditingController: descriptionController,
                hintText: "Enter a Detailed Description",
                textInputType: TextInputType.text,
                maxlines: 3,
              ),
              largeSpacing(context),
              Text(
                "Task Deadline :",
                style: boldTextStyle,
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
              Text(
                "Task Estimated Time :",
                style: boldTextStyle,
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
              Text(
                "Completion Status",
                style: boldTextStyle,
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
                      backgroundColor: blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () async {
                    String? uid = FirebaseAuth.instance.currentUser?.uid;
                    if (uid != null &&
                        titleController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty &&
                        dateController.text.isNotEmpty &&
                        timeController.text.isNotEmpty &&
                        estimatedController.text.isNotEmpty) {
                      try {
                        var fireStore = FirebaseFirestore.instance;
                        var userDocRef = fireStore.collection("users").doc(uid);
                        var tasksCollectionRef = userDocRef.collection('tasks');
                        await tasksCollectionRef.add({
                          'title': titleController.text,
                          'description': descriptionController.text,
                          'deadlineDate': dateController.text,
                          'deadlineTime': timeController.text,
                          'estimatedTime': estimatedController.text,
                          'completionStatus': completionStatus,
                        });

                        DateTime deadlineDateTime = DateTime(
                          _dateTime.year,
                          _dateTime.month,
                          _dateTime.day,
                          _deadlineTime.hour,
                          _deadlineTime.minute,
                        );

                        scheduleNotification(
                            titleController.text, deadlineDateTime);

                        await showSnackBar(
                            context, "Task Assigned successfully");

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
                    } else {
                      showSnackBar(context, "Please fill in all fields");
                    }
                  },
                  child: Text(
                    "Assign a Task",
                    style: differColor(white),
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

  void updateDeadlineTimeController() {
    String period = _deadlineTime.period == DayPeriod.am ? 'AM' : 'PM';
    timeController.text =
        "${_deadlineTime.hourOfPeriod}:${_deadlineTime.minute.toString().padLeft(2, '0')} $period";
  }

  void updateEstimatedTimeController() {
    String period = _estimatedTime.period == DayPeriod.am ? 'AM' : 'PM';
    estimatedController.text =
        "${_estimatedTime.hourOfPeriod}:${_estimatedTime.minute.toString().padLeft(2, '0')} $period";
  }

  void scheduleNotification(String title, DateTime deadline) async {
    final scheduledNotificationDateTime =
        deadline.subtract(const Duration(minutes: 10));

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'task_reminder',
      'Task Reminder',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(
      title.hashCode,
      'Task Reminder',
      'Your task "$title" is due in 10 minutes',
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
    );
  }
}
