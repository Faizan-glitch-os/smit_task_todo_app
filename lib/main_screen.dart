import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool checkboxBool = true;

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
                      style: TextStyle(fontSize: 10.sp),
                      maxLines: null,
                      decoration: InputDecoration(
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
                        onPressed: () {},
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              Container(
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
                    Text('container'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
