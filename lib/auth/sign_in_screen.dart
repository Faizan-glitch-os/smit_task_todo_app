import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smit_task_todo_app/auth/user-auth_class.dart';
import 'package:smit_task_todo_app/ui/main_screen.dart';
import 'package:smit_task_todo_app/utils/flutter_toasts_package.dart';
import 'package:smit_task_todo_app/widgets/text_clear_button_widget.dart';

import '../widgets/text_form_field_widget.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final signInKey = GlobalKey<FormState>();
  late bool loading = false;
  late bool textObscure = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // void isLoading() {
  //   setState(() {
  //     loading != loading;
  //   });
  // }

  void signInUser(context) {
    if (signInKey.currentState!.validate()) {
      setState(() {
        loading = !loading;
      });
      auth
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) {
        Toasts().success('User Signed In Successfully');
        setState(() {
          loading = !loading;
        });
        emailController.clear();
        passwordController.clear();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const MainScreen();
        }));
      }).onError((error, value) {
        setState(() {
          loading = !loading;
        });
        Toasts().fail(error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8).r,
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: signInKey,
              child: Column(
                children: [
                  TextFormFieldWidget(
                    fieldText: 'Email',
                    lastIcon:
                        TextClearButtonWidget(textController: emailController),
                    textController: emailController,
                    validate: (email) {
                      if (email.isEmpty) {
                        Toasts().fail('Please enter a valid Email');
                      }
                      return null;
                    },
                    hintText: 'Pakistan@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                    linesCount: null,
                  ),
                  SizedBox(height: 20.h),
                  TextFormFieldWidget(
                      fieldText: 'Password',
                      lastIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            textObscure = !textObscure;
                          });
                        },
                        icon: textObscure
                            ? Icon(
                                CupertinoIcons.eye_solid,
                                size: 20.r,
                              )
                            : Icon(
                                CupertinoIcons.eye_slash_fill,
                                size: 20.r,
                              ),
                      ),
                      textController: passwordController,
                      validate: (password) {
                        if (password.isEmpty) {
                          Toasts().fail('Please enter a valid Password');
                        }
                        return null;
                      },
                      hintText: 'Password',
                      obscureText: textObscure),
                  SizedBox(height: 30.h),
                  ElevatedButton(
                    onPressed: () {
                      if (signInKey.currentState!.validate()) {
                        signInUser(context);
                      }
                    },
                    child: loading
                        ? const CircularProgressIndicator(
                            color: Colors.purple,
                          )
                        : Text(
                            'Sign IN',
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
                                text: 'Don\'t have an account,',
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.black)),
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUpScreen()));
                                  },
                                text: ' Sign Up now',
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.deepPurple)),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
