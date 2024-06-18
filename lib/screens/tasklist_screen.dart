import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_assigner/Widgets/rich_text.dart';
import 'package:task_assigner/Widgets/snackbar.dart';
import 'package:task_assigner/Widgets/text_styles.dart';
import 'package:task_assigner/widgets/navigation.dart';

import '../main.dart';
import 'taskedit_screen.dart';
import '../Widgets/spacing.dart';
import '../constants/colors.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Tasks"),
        ),
        body: const Center(
          child: Text("No user logged in"),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        title:  Text("Tasks List", style: differColor(white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('tasks')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading tasks"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No tasks available"));
          }

          var tasks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              var task = tasks[index];
              var taskData = task.data() as Map<String, dynamic>;

              String statusText = 'No Status';
              if (taskData['completionStatus'] is Map) {
                var completionStatus =
                taskData['completionStatus'] as Map<String, dynamic>;
                if (completionStatus['completed'] == true) {
                  statusText = 'Completed';
                } else if (completionStatus['onProgress'] == true) {
                  statusText = 'On Progress';
                }
              } else if (taskData['completionStatus'] is String) {
                statusText = taskData['completionStatus'];
              }

              return SingleChildScrollView(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      // Adjust the radius as needed
                      side: BorderSide(
                          color: grey, width: 1), // Add border
                    ),
                    elevation: 10,
                    child: ListTile(
                        title: CustomRichText(
                            boldText: "Title :",
                            italicText: taskData['title'] ?? 'No title',
                            italicTextColor: indigo),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            mediumSpacing(context),
                            CustomRichText(
                                boldText: "Description :",
                                italicText:
                                taskData['description'] ?? 'No Description',
                                italicTextColor: grey),
                            mediumSpacing(context),
                            CustomRichText(
                                boldText: "DeadlineDate :",
                                italicText:
                                taskData['deadlineDate'] ?? 'No deadlineDate',
                                italicTextColor: red),
                            mediumSpacing(context),
                            CustomRichText(
                                boldText: "DeadlineTime :",
                                italicText:
                                taskData['deadlineTime'] ?? 'No deadlineTime',
                                italicTextColor: red),
                            mediumSpacing(context),
                            CustomRichText(
                                boldText: "Estimated Time:",
                                italicText: taskData['estimatedTime'] ??
                                    'No Estimated Time',
                                italicTextColor: brown),
                            mediumSpacing(context),
                            Row(
                              children: [
                                const CustomRichText(
                                  boldText: "STATUS:  ",
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: statusText == 'Completed'
                                        ? green
                                        : statusText == 'On Progress'
                                        ? red
                                        : blue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child:
                                  CustomRichText(boldText: statusText ?? 'No'),
                                ),
                              ],
                            ),
                            mediumSpacing(context),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  _deleteTask(task.id, uid, context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color:indigo,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text("🗑️ Delete this task", style: TextStyle(color: white, fontWeight: FontWeight.bold),)),
                              ),
                            )
                          ],
                        ),
                        trailing: GestureDetector(
                            onTap: () {
                              navigatesToScreen(context, TaskEditScreen(
                                taskData: taskData,
                                taskId: task.id,
                              ),);
                            },
                            child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text("✎ Edit",style: TextStyle(fontWeight: FontWeight.bold,color: black),)))),
                  ));
            },
          );
        },
      ),
    );
  }

  void _deleteTask(String taskId, String uid, BuildContext context) async {
    try {
      var _firestore = FirebaseFirestore.instance;
      var userDocRef = _firestore.collection("users").doc(uid);
      var tasksCollectionRef = userDocRef.collection('tasks');

      await tasksCollectionRef.doc(taskId).delete();

      showSnackBar(context, "Task deleted successfully");
    } catch (e) {
      print("Error deleting task: $e");

      showSnackBar(context, "Failed to delete task");
    }
  }



}
