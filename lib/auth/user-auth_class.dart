// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../ui/main_screen.dart';
// import '../utils/flutter_toasts_package.dart';
// import 'sign_in_screen.dart';
//
// class UserAuth {
//   void signInUser(
//       isLoading, auth, emailController, passwordController, context) {
//     isLoading;
//     auth
//         .signInWithEmailAndPassword(
//             email: emailController.text.trim(),
//             password: passwordController.text.trim())
//         .then((value) {
//       Toasts().success('User Signed In Successfully');
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
//         return const MainScreen();
//       }));
//     }).onError((error, value) {
//       isLoading;
//       Toasts().fail(error);
//     });
//   }
//
//   void signUpUser(
//       isLoading, auth, emailController, passwordController, context) {
//     isLoading;
//     auth
//         .createUserWithEmailAndPassword(
//             email: emailController.text.trim(),
//             password: passwordController.text.trim())
//         .then((value) {
//       Toasts().success('Signed UP Successfully');
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
//         return const SignInScreen();
//       }));
//     }).onError((error, value) {
//       isLoading;
//       Toasts().fail(error);
//     });
//   }
// }
