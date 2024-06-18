import 'package:flutter/material.dart';
import 'package:task_assigner/Widgets/text_styles.dart';

import '../Widgets/snackbar.dart';
import '../constants/colors.dart';
import '../screens/login_screen.dart';
import 'navigation.dart';


void showMyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return  AlertDialog(
        title:  Text(
          "TASK ASSIGNER",
          style: differColor(blue)
        ),
        content: Text(
          "Are you sure want to Logout ?",
          style: differColor(black)
        ),
        actions: <Widget>[
          TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);

            },
            child: const Text(
              "CANCEL",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: white,
              ),
            ),
          ),
          TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            onPressed: () {
              navigateToScreen(context, const LoginScreen());
              showSnackBar(context, "LogOut is Successfully Done");

            },
            child: const Text(
              "OK",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: white,
              ),
            ),
          ),
        ],
      );
    },
  );


}


