import 'package:ambros_app/utils/size_util.dart';
import 'package:ambros_app/utils/words_util.dart';
import 'package:flutter/material.dart';

class BaseComponents{
  Widget buttonUtil(
      {String title = '${WordsUtil.exit}',
        Color? background,
        Color titleColor = Colors.white,
        Function? handleOnPress}) {
    return ElevatedButton(
      onPressed: () => handleOnPress!(),
      style: ElevatedButton.styleFrom(
          primary: background != null
              ? background
              : Colors.red,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(SizeUtil.borderRadiusDefault),
          )),
      child: Padding(
        padding: const EdgeInsets.all(SizeUtil.padding16),
        child: Text(
          '$title',
          style: TextStyle(
              fontSize: 16, color: titleColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}