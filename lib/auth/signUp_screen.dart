import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smit_task_todo_app/auth/signIn_screen.dart';
import 'package:smit_task_todo_app/auth/user-auth_class.dart';
import 'package:smit_task_todo_app/utils/flutter-toasts_package.dart';

import '../widgets/textFormField_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final signUpKey = GlobalKey<FormState>();
  late bool loading = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  // void isLoading() {
  //   setState(() {
  //     loading != loading;
  //   });
  // }

  void signUpUser(context) {
    setState(() {
      loading = true;
    });
    auth
        .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((value) {
      Toasts().success('Signed UP Successfully');
      setState(() {
        loading = false;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const SignInScreen();
      }));
    }).onError((error, value) {
      setState(() {
        loading = false;
      });
      Toasts().fail(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8).r,
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: signUpKey,
              child: Column(
                children: [
                  TextFormFieldWidget(
                    textController: emailController,
                    validate: (email) {
                      if (email!.isEmpty) {
                        Toasts().fail('Please enter a valid Email');
                      }
                      return null;
                    },
                    hintText: 'Email e.g Pakistan@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                    linesCount: null,
                  ),
                  SizedBox(height: 20.h),
                  TextFormFieldWidget(
                      textController: passwordController,
                      validate: (password) {
                        print('validator');
                        if (password!.isEmpty) {
                          Toasts().fail('Please enter Password');
                        }
                        return null;
                      },
                      hintText: 'Password',
                      obscureText: true),
                  SizedBox(height: 30.h),
                  ElevatedButton(
                    onPressed: () {
                      if (signUpKey.currentState!.validate()) {
                        // UserAuth().signUpUser(isLoading, auth,
                        //     emailController, passwordController, context);
                        signUpUser(context);
                      }
                    },
                    child: loading
                        ? const CircularProgressIndicator(
                            color: Colors.purple,
                          )
                        : Text(
                            'Sign UP',
                            style: TextStyle(fontSize: 15.sp),
                          ),
                  ),
                  SizedBox(height: 40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Already have an account,',
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.black)),
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignInScreen()));
                                  },
                                text: ' Sign In now',
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.deepPurple)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
