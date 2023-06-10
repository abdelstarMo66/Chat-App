import 'package:chat_app/sheared/color_manager/color.dart';
import 'package:flutter/material.dart';

void showProgress(context) {
  showDialog(
    barrierColor: Colors.white.withOpacity(0),
    barrierDismissible: false,
    context: context,
    builder: (context) => const AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(ColorManager.mainColor),
        ),
      ),
    ),
  );
}
