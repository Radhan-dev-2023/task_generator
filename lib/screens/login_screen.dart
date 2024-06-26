import 'package:flutter/material.dart';


import '../../Services/authentication.dart';

import '../widgets/navigation.dart';
import 'home_Screen.dart';
import 'signup_screen.dart';
import '../Widgets/buttons.dart';
import '../Widgets/snackbar.dart';
import '../Widgets/text_field.dart';
import '../constants/colors.dart';



class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }


 Future <void> loginUser() async {
    setState(() {
      isLoading = true;
    });
   
    String res = await AuthMethod().loginUser(
        email: emailController.text, password: passwordController.text);

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      navigateToScreen(context, const HomeScreen());
    } else {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: white,
      body: SafeArea(
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height / 2.8,
                  child: Image.network("https://static.vecteezy.com/system/resources/previews/006/901/769/non_2x/secure-login-and-sign-up-concept-illustration-vector.jpg"),
                ),
                TextFieldInput(
                  maxlines: 1,
                    icon: Icons.person,
                    textEditingController: emailController,
                    hintText: 'Enter your E-mail',
                    textInputType: TextInputType.emailAddress),
                TextFieldInput(
                  maxlines: 1,
                  icon: Icons.lock,
                  textEditingController: passwordController,
                  hintText: 'Enter your Password',
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                MyButtons(onTap: loginUser, text: "Log In"),

                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(height: 1, color: black),
                    ),
                    const Text("  or  "),
                    Expanded(
                      child: Container(height: 1, color:black),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        navigatesToScreen(context, const SignupScreen());
                      },
                      child: const Text(
                        "SignUp",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}