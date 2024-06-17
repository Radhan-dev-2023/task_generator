

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;



  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          name.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(cred.user!.uid);
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'name': name,
          'uid': cred.user!.uid,
          'email': email,
        });
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userid', cred.user!.uid);

        res = "success";

      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }


  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";

      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }


  signOut() async {
    // await _auth.signOut();
  }
}

/*
class TaskManagement {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void assignTask(BuildContext context) async {
    try {
      // Get current user
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Construct task data
      Map<String, dynamic> taskData = {
        'title': 'Sample Task',
        'description': 'This is a sample task created on ${DateTime.now()}',
        'deadline': Timestamp.fromDate(DateTime.now().add(Duration(days: 7))),
        'estimatedTime': Timestamp.fromDate(DateTime.now().add(Duration(hours: 2))),
        'isCompleted': false,
        'isInProgress': true,
      };
      // Save the task under 'tasks' collection for the user
      await _firestore.collection("users").doc(user.uid).collection('tasks').add(taskData);

      // Show success message or update UI accordingly
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sample task assigned successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      print('Error assigning task: $error');
      // Handle error: Show error message or update UI accordingly
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to assign task. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}*/
