import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextClearButtonWidget extends StatelessWidget {
  const TextClearButtonWidget({
    super.key,
    required this.textController,
  });

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        textController.clear();
      },
      icon: Icon(
        Icons.clear,
        size: 20.r,
      ),
    );
  }
}
