import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smit_task_todo_app/utils/flutter_toasts_package.dart';
import 'package:smit_task_todo_app/widgets/text_clear_button_widget.dart';
import 'package:smit_task_todo_app/widgets/text_form_field_widget.dart';

class AddNewToDoWidget extends StatelessWidget {
  AddNewToDoWidget({
    super.key,
  });

  final _formKey = GlobalKey<FormState>();

  final TextEditingController newToDoTitleController = TextEditingController();
  final TextEditingController newToDoDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20).r,
        child: Form(
          key: _formKey,
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
              // TextFormField(
              //   controller: newToDoController,
              //   style: TextStyle(fontSize: 10.sp),
              //   maxLines: null,
              //   decoration: InputDecoration(
              //       suffixIcon: IconButton(
              //         onPressed: () {
              //           newToDoController.clear();
              //         },
              //         icon: Icon(
              //           Icons.clear,
              //           size: 20.r,
              //         ),
              //       ),
              //       hintText: 'Add a new To-do',
              //       hintStyle: TextStyle(
              //           color: Colors.black12, fontSize: 10.sp),
              //       border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(10.r),
              //           borderSide: BorderSide.none),
              //       fillColor: Colors.black12,
              //       filled: true),
              // ),
              SizedBox(height: 50.h),
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
                    // if (newToDoController.text.isNotEmpty) {
                    //   addNewToDo(newToDoController.text);
                    //   newToDoController.clear();
                    //   Navigator.pop(context);
                    // } else {}
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
