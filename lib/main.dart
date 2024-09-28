import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smit_task_todo_app/auth/sign_in_screen.dart';

import 'auth/sign_up_screen.dart';
import 'ui/splash_screen.dart';
import 'ui/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCkseMpdc8SUY58AOPFSIqU5Vry_Teljrs",
          authDomain: "smit-todo-eb644.firebaseapp.com",
          databaseURL: "https://smit-todo-eb644-default-rtdb.firebaseio.com",
          projectId: "smit-todo-eb644",
          storageBucket: "smit-todo-eb644.appspot.com",
          messagingSenderId: "975169574140",
          appId: "1:975169574140:web:f60650009e7f0aebd03379"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      ensureScreenSize: true,
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          home: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.noScaling),
              child: auth.currentUser != null
                  ? const MainScreen()
                  : const SignUpScreen()),
        );
      },
    );
  }
}
