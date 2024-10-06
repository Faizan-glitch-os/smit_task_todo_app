import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:smit_task_todo_app/utils/flutter_toasts_package.dart';
import 'package:smit_task_todo_app/widgets/text_clear_button_widget.dart';
import 'package:smit_task_todo_app/widgets/text_form_field_widget.dart';

class AddNewToDoWidget extends StatefulWidget {
  const AddNewToDoWidget({
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

  DatabaseReference db = FirebaseDatabase.instance.ref('todo');

  FirebaseAuth auth = FirebaseAuth.instance;

  void addNewToDo() {
    setState(() {
      addingData = !addingData;
    });

    String id = DateTime.now().millisecondsSinceEpoch.toString();
    db.child(id).set({
      'uid': auth.currentUser!.uid,
      'id': id,
      'title': newToDoTitleController.text.trim().toString(),
      'description': newToDoDescriptionController.text.trim().toString(),
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
      padding: const EdgeInsets.symmetric(horizontal: 20).r,
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
                  fieldText: 'Title',
                  hintText: 'Enter Title',
                  validate: (title) {
                    if (title.isEmpty || title == null) {
                      return 'Please enter a Title';
                    }
                    return null;
                  },
                  textController: newToDoTitleController,
                  lastIcon: TextClearButtonWidget(
                      textController: newToDoTitleController),
                ),
                SizedBox(height: 10.h),
                TextFormFieldWidget(
                  fieldText: 'Description',
                  linesCount: 5,
                  hintText: 'Enter Description',
                  validate: (description) {
                    if (description.isEmpty) {
                      return 'Please enter Description';
                    }
                    return null;
                  },
                  textController: newToDoDescriptionController,
                  lastIcon: TextClearButtonWidget(
                      textController: newToDoDescriptionController),
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
