import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:smit_task_todo_app/utils/flutter_toasts_package.dart';
import 'package:smit_task_todo_app/widgets/text_clear_button_widget.dart';
import 'package:smit_task_todo_app/widgets/text_form_field_widget.dart';

class UpdateToDoWidget extends StatefulWidget {
  UpdateToDoWidget(
      {super.key,
      required this.id,
      required this.title,
      required this.description});

  final String id;
  final String title;
  final String description;

  @override
  State<UpdateToDoWidget> createState() => _UpdateToDoWidgetState();
}

class _UpdateToDoWidgetState extends State<UpdateToDoWidget> {
  final _formKey = GlobalKey<FormState>();
  bool editingData = false;

  final TextEditingController editToDoTitleController = TextEditingController();
  final TextEditingController editToDoDescriptionController =
      TextEditingController();

  DatabaseReference db = FirebaseDatabase.instance.ref('todo');

  void editToDo() {
    setState(() {
      editingData = !editingData;
    });

    db.child(widget.id).update({
      'title': editToDoTitleController.text.toString().trim(),
      'description': editToDoDescriptionController.text.toString().trim(),
    }).then((value) {
      setState(() {
        editingData = !editingData;
      });

      editToDoTitleController.clear();
      editToDoDescriptionController.clear();
      Toasts().success('To-do edited Successfully');
      Navigator.pop(context);
    }).onError((error, value) {
      setState(() {
        editingData = !editingData;
      });
      print(error.toString());
      Toasts().fail(error.toString());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    editToDoTitleController.text = widget.title;
    editToDoDescriptionController.text = widget.description;
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
                'Edit To-do',
                style: TextStyle(fontSize: 15.sp),
              ),
              IconButton(
                onPressed: () {
                  editToDoTitleController.clear();
                  editToDoDescriptionController.clear();
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
                  textController: editToDoTitleController,
                  lastIcon: TextClearButtonWidget(
                      textController: editToDoTitleController),
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
                  textController: editToDoDescriptionController,
                  lastIcon: TextClearButtonWidget(
                      textController: editToDoDescriptionController),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        editToDo();
                      }
                    },
                    child: editingData
                        ? const CircularProgressIndicator(
                            color: Colors.purple,
                          )
                        : Text(
                            'Edit',
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
