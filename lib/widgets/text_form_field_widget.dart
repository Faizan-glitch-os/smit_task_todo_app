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
      this.fieldText = '',
      // this.initialValue = '',
      this.onChange,
      required this.validate,
      required this.textController,
      required this.lastIcon});

  final String hintText;
  final bool obscureText;
  final keyboardType;
  final linesCount;
  final FormFieldValidator validate;
  final TextEditingController textController;
  final Widget lastIcon;
  final String fieldText;
  final Function(String)? onChange;
  // final String initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        // initialValue: initialValue,
        onChanged: (value) {
          if (onChange != null) {
            onChange!(value);
          }
        },
        controller: textController,
        validator: validate,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: linesCount,
        style: TextStyle(fontSize: 12.sp),
        decoration: InputDecoration(
            labelText: fieldText,
            labelStyle: TextStyle(
                fontSize: 15.sp,
                color: Colors.deepPurpleAccent.withOpacity(.7)),
            suffixIcon: lastIcon,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black12, fontSize: 10.sp),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none),
            fillColor: Colors.black12,
            filled: true));
  }
}
