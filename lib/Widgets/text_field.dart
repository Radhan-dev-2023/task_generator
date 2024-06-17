import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final int? maxlines;
  final IconData? icon;
  final TextInputType textInputType;
  final VoidCallback? onIconTap;
  final bool? readonly;
  const TextFieldInput({
    super.key,
    required this.textEditingController,
    this.isPass = false,
    this.maxlines,
    this.onIconTap,
    required this.hintText,
    this.icon,
    required this.textInputType,  this.readonly,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        readOnly: readonly??false,
        style: const TextStyle(fontSize: 20),
        controller: textEditingController,
        decoration: InputDecoration(
          prefixIcon: InkWell(
              onTap: onIconTap,
              child: Icon(icon, color: Colors.black54)),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black45, fontSize: 18),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30),
          ),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: const Color(0xFFedf0f8),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
        ),
        keyboardType: textInputType,
        obscureText: isPass,
        maxLines: maxlines,
      ),
    );
  }
}
class TextFieldInputs extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final int? maxlines;
  final IconData? icon;
  final TextInputType textInputType;
  final VoidCallback? onIconTap;
  final bool? readonly;
  const TextFieldInputs({
    super.key,
    required this.textEditingController,
    this.isPass = false,
    this.maxlines,
    this.onIconTap,
    required this.hintText,
    this.icon,
    required this.textInputType,  this.readonly,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Container(
        width: MediaQuery.of(context).size.width*0.4,
        child: TextField(
          readOnly: readonly??false,
          style: const TextStyle(fontSize: 18),
          controller: textEditingController,
          decoration: InputDecoration(
            prefixIcon: InkWell(
                onTap: onIconTap,
                child: Icon(icon, color: Colors.black54)),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black45, fontSize: 18),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(30),
            ),
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(30),
            ),
            filled: true,
            fillColor: const Color(0xFFedf0f8),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 15,
              horizontal: 20,
            ),
          ),
          keyboardType: textInputType,
          obscureText: isPass,
          maxLines: maxlines,
        ),
      ),
    );
  }
}

Widget customTextFields(

     TextEditingController controller,
     String text,
{int? maxlines=1}
    ){
  return   TextField(
    maxLines: maxlines,
    controller: controller,
    decoration: InputDecoration(labelText: text,labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.black),border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: BorderSide(
        color: Colors.blue,width: 10,
      ),
    ),),
  );
}