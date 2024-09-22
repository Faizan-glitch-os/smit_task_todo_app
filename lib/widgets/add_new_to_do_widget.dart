import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:smit_task_todo_app/utils/flutter_toasts_package.dart';
import 'package:smit_task_todo_app/widgets/text_clear_button_widget.dart';
import 'package:smit_task_todo_app/widgets/text_form_field_widget.dart';

class AddNewToDoWidget extends StatefulWidget {
  AddNewToDoWidget({
    super.key,
  });

  @override
  State<AddNewToDoWidget> createState() => _AddNewToDoWidgetState();
}

class _AddNewToDoWidgetState extends State<AddNewToDoWidget> {
  final _formKey = GlobalKey<FormState>();
  bool addingData = false;

  final TextEditingController newToDoTitleController = TextEditingController();
  final TextEditingController newToDoDescriptionController =
      TextEditingController();

  DatabaseReference db = FirebaseDatabase.instance.ref('smit-todo');

  void addNewToDo() {
    setState(() {
      addingData = !addingData;
    });

    String id = DateTime.now().millisecondsSinceEpoch.toString();
    db.child(id).set({
      'id': id,
      'title': newToDoTitleController.text.toString().trim(),
      'description': newToDoDescriptionController.text.toString().trim(),
    }).then((value) {
      setState(() {
        addingData = !addingData;
      });

      newToDoTitleController.clear();
      newToDoDescriptionController.clear();
      Toasts().success('To-do added Successfully');
      Navigator.pop(context);
    }).onError((error, value) {
      setState(() {
        addingData = !addingData;
      });
      print(error.toString());
      Toasts().fail(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20).r,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                  newToDoTitleController.clear();
                  newToDoDescriptionController.clear();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  size: 25.r,
                ),
              )
            ],
          ),
          SizedBox(height: 50.h),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormFieldWidget(
                  hintText: 'Enter Title',
                  validate: (title) {
                    if (title!.isEmpty) {
                      Toasts().fail('Please enter a Title');
                    }
                    return null;
                  },
                  textController: newToDoTitleController,
                  lastIcon: TextClearButtonWidget(
                      emailController: newToDoTitleController),
                ),
                SizedBox(height: 10.h),
                TextFormFieldWidget(
                  linesCount: 5,
                  hintText: 'Enter Description',
                  validate: (description) {
                    if (description!.isEmpty) {
                      Toasts().fail('Please enter Description');
                    }
                    return null;
                  },
                  textController: newToDoDescriptionController,
                  lastIcon: TextClearButtonWidget(
                      emailController: newToDoDescriptionController),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        addNewToDo();
                      }
                    },
                    child: addingData
                        ? const CircularProgressIndicator(
                            color: Colors.purple,
                          )
                        : Text(
                            'Save',
                            style: TextStyle(fontSize: 15.sp),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
