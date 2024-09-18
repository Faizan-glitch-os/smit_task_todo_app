import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smit_task_todo_app/auth/sign_in_screen.dart';
import 'package:smit_task_todo_app/utils/flutter_toasts_package.dart';
import 'package:smit_task_todo_app/widgets/text_form_field_widget.dart';

import '../widgets/add_new_to_do_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> allToDo = [];
  bool loading = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    loadToDo();
  }

  Future<void> loadToDo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      allToDo = prefs.getStringList('savedToDo') ?? [];
    });
  }

  Future<void> saveToDo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('savedToDo', allToDo);
  }

  void addNewToDo(String toDo) {
    if (toDo.isNotEmpty) {
      setState(() {
        allToDo.add(toDo);
      });
    }
    saveToDo();
  }

  void removeToDo(int index) {
    setState(() {
      allToDo.removeAt(index);
    });
    saveToDo();
  }

  void signOut(context) {
    setState(() {
      loading = true;
    });
    auth.signOut().then((value) {
      Toasts().success('Signed Out Successfully');
      loading != loading;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const SignInScreen();
      }));
    }).onError((error, value) {
      loading = false;
      Toasts().fail(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-do'),
        actions: [
          loading
              ? const CircularProgressIndicator(
                  color: Colors.deepPurple,
                )
              : IconButton(
                  onPressed: () {
                    signOut(context);
                  },
                  icon: Icon(
                    Icons.logout_rounded,
                    size: 25.r,
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(auth.currentUser!.email);
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return AddNewToDoWidget();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: allToDo.isNotEmpty
          ? ListView.builder(
              itemCount: allToDo.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5.h),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10.r)),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  removeToDo(index);
                                },
                                icon: Icon(
                                  Icons.close,
                                  size: 20.r,
                                )),
                            Text(allToDo[index]),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })
          : Center(
              child: Text(
                textAlign: TextAlign.center,
                'No To-do added, kindly add one',
                style: TextStyle(fontSize: 20.sp),
              ),
            ),
    );
  }
}
