import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFormFieldWidget extends StatelessWidget {
  const TextFormFieldWidget(
      {super.key,
      required this.hintText,
      this.obscureText = false,
      this.keyboardType = TextInputType.text,
      this.linesCount = 1,
      required this.validate,
      required this.textController});

  final String hintText;
  final bool obscureText;
  final keyboardType;
  final linesCount;
  final FormFieldValidator validate;
  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: textController,
        validator: validate,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: linesCount,
        style: TextStyle(fontSize: 12.sp),
        decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.clear,
                size: 20.r,
              ),
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black12, fontSize: 10.sp),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none),
            fillColor: Colors.black12,
            filled: true));
  }
}
