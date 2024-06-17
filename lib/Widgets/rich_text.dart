import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {
  final String? boldText;
  final String? italicText;
  final Color? italicTextColor;

  const CustomRichText({
    Key? key,
     this.boldText,
     this.italicText,
     this.italicTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: boldText,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 20),
          ),
          TextSpan(
            text: italicText,
            style:  TextStyle(fontWeight: FontWeight.w600, color: italicTextColor,fontSize: 16),
          ),
        ],
      ),
    );
  }
}
