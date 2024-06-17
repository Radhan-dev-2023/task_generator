import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_assigner/Widgets/rich_text.dart';

import 'Edit_screen.dart';
import 'Widgets/spacing.dart';

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
        backgroundColor: Colors.blue,
        title: const Text("Tasks", style: TextStyle(color: Colors.white)),
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
                      color: Colors.grey.shade400, width: 1), // Add border
                ),
                elevation: 10,
                child: ListTile(
                    title: CustomRichText(
                        boldText: "Title :",
                        italicText: taskData['title'] ?? 'No title',
                        italicTextColor: Colors.indigo),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        mediumSpacing(context),
                        CustomRichText(
                            boldText: "Description :",
                            italicText:
                                taskData['description'] ?? 'No Description',
                            italicTextColor: Colors.grey.shade700),
                        mediumSpacing(context),
                        CustomRichText(
                            boldText: "DeadlineDate :",
                            italicText:
                                taskData['deadlineDate'] ?? 'No deadlineDate',
                            italicTextColor: Colors.red),
                        mediumSpacing(context),
                        CustomRichText(
                            boldText: "DeadlineTime :",
                            italicText:
                                taskData['deadlineTime'] ?? 'No deadlineTime',
                            italicTextColor: Colors.red),
                        mediumSpacing(context),
                        CustomRichText(
                            boldText: "Estimated Time:",
                            italicText: taskData['estimatedTime'] ??
                                'No Estimated Time',
                            italicTextColor: Colors.brown),
                        mediumSpacing(context),
                        Row(
                          children: [
                            CustomRichText(
                              boldText: "STATUS:  ",
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: statusText == 'Completed'
                                    ? Colors.green
                                    : statusText == 'On Progress'
                                        ? Colors.red
                                        : Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child:
                                  CustomRichText(boldText: statusText ?? 'No'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskEditScreen(
                                taskData: taskData,
                                taskId: task.id,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                            child: Text("Edit",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)))),
              ));
            },
          );
        },
      ),
    );
  }
}
