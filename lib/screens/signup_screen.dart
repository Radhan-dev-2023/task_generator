import 'package:flutter/material.dart';
import 'package:task_assigner/Widgets/spacing.dart';
import 'package:task_assigner/widgets/navigation.dart';


import '../../Services/authentication.dart';

import 'home_Screen.dart';
import 'login_screen.dart';
import '../Widgets/buttons.dart';
import '../Widgets/snackbar.dart';
import '../Widgets/text_field.dart';



class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  void signupUser() async {

    setState(() {
      isLoading = true;
    });

    String res = await AuthMethod().signupUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text);
    if (res == "success") {
      setState(() {
        isLoading = false;
      });

     navigateToScreen(context, const HomeScreen());
    }
    else {
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
      body: SafeArea(
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height / 2.8,
                  child: Image.network("https://st.depositphotos.com/18722762/51522/v/450/depositphotos_515228776-stock-illustration-online-registration-sign-login-account.jpg"),
                ),
                TextFieldInput(
                  maxlines: 1,
                    icon: Icons.person,
                    textEditingController: nameController,
                    hintText: 'Enter your name',
                    textInputType: TextInputType.text),
                TextFieldInput(
                  maxlines: 1,
                    icon: Icons.email,
                    textEditingController: emailController,
                    hintText: 'Enter your email',
                    textInputType: TextInputType.text),
                TextFieldInput(
                  maxlines: 1,
                  icon: Icons.lock,
                  textEditingController: passwordController,
                  hintText: 'Enter your password',
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                MyButtons(onTap: signupUser, text: "Sign Up"),
                largeSpacing(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    GestureDetector(
                      onTap: () {
                        navigatesToScreen(context,const LoginScreen());
                      },
                      child: const Text(
                        " Login",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                mediumSpacing(context),
              ],
            ),
          )),
    );
  }
}