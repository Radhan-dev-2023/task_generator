import 'package:flutter/material.dart';

Widget mediumSpacing(BuildContext context){
  return SizedBox(
    height: MediaQuery.of(context).size.height*0.02,
  );
}

Widget largeSpacing(BuildContext context,){
  return SizedBox(
    height: MediaQuery.of(context).size.height*0.03,
  );
}