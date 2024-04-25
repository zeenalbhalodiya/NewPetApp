import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet/components/app_text_style.dart';
import 'package:pet/components/colors.dart';

class PrimaryTextButton extends StatelessWidget {
  String? title;
  VoidCallback onPressed;
  Color? buttonColor;
  Color? textColor;
  double? width;
  double? height;
  BorderSide? border;
  bool autofocus;
  Color? titleColor;
  BorderRadiusGeometry? borderRadius;

  PrimaryTextButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.buttonColor,
    this.textColor,
    this.border,
    this.width,
    this.height,
    this.titleColor,
    this.borderRadius,
    this.autofocus = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      autofocus: autofocus,
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? primaryWhite, shape: RoundedRectangleBorder(
          side: border ?? BorderSide.none,
          borderRadius: borderRadius ?? BorderRadius.circular(12),
        ), disabledForegroundColor: primaryWhite.withOpacity(0.38),
        backgroundColor: buttonColor ?? appColor,
        fixedSize: Size(
          width ?? Get.width,
          height ?? 50,
        ),
        alignment: Alignment.center,
        textStyle: const TextStyle(
          fontSize: 16,
          debugLabel: "Title",
          fontWeight: FontWeight.w500,
        ),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title.toString(),
          softWrap: true,
          textAlign: TextAlign.center,
          style: AppTextStyle.normalSemiBold14
              .copyWith(color: titleColor ?? primaryWhite),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
