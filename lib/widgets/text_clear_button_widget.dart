import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextClearButtonWidget extends StatelessWidget {
  const TextClearButtonWidget({
    super.key,
    required this.emailController,
  });

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        emailController.clear();
      },
      icon: Icon(
        Icons.clear,
        size: 20.r,
      ),
    );
  }
}
