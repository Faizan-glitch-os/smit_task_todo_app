import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smit_task_todo_app/auth/signIn_screen.dart';
import 'package:smit_task_todo_app/utils/flutter-toasts_package.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool checkboxBool = true;
  List<String> allToDo = [];
  bool loading = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController newToDoController = TextEditingController();

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
    newToDoController.clear();
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
        title: Text('To-do'),
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
                )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.r),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'New To-do',
                          style: TextStyle(fontSize: 15.sp),
                        ),
                        IconButton(
                          onPressed: () {
                            newToDoController.clear();
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            size: 25.r,
                          ),
                        )
                      ],
                    ),
                    TextField(
                      controller: newToDoController,
                      style: TextStyle(fontSize: 10.sp),
                      maxLines: null,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              newToDoController.clear();
                            },
                            icon: Icon(
                              Icons.clear,
                              size: 20.r,
                            ),
                          ),
                          hintText: 'Add a new To-do',
                          hintStyle:
                              TextStyle(color: Colors.black12, fontSize: 10.sp),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none),
                          fillColor: Colors.black12,
                          filled: true),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          if (newToDoController.text.isNotEmpty) {
                            addNewToDo(newToDoController.text);
                            newToDoController.clear();
                            Navigator.pop(context);
                          } else {}
                        },
                        child: Text('Save'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
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
