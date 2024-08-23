import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool checkboxBool = true;
  List<String> allToDo = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-do'),
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
                            Checkbox(
                              value: checkboxBool,
                              onChanged: (value) {
                                setState(
                                  () {
                                    checkboxBool = value!;
                                  },
                                );
                              },
                            ),
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
