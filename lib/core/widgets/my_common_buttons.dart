import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hipster/core/widgets/app_text.dart';
import '../constants/app_colors.dart';

class MyFilledButton extends StatelessWidget {
  final String title;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final Function()? function;
  final double? height;
  final bool isLoading;

  const MyFilledButton({
    super.key,
    required this.title,
    this.color,
    this.height,
    this.margin,
    required this.function,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        alignment: Alignment.center,
        margin: margin,
        height: height ?? 55,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(10),
          color: color ?? Colors.cyan,
        ),
        child: isLoading
            ? SpinKitWave(size: 20, color: AppColor.white)
            : AppText(
                text: title,
                color: AppColor.whiteColor,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
      ),
    );
  }
}

class MyBorderButton extends StatelessWidget {
  final String title;
  final Color? borderColor;
  final EdgeInsetsGeometry? margin;
  final Function function;
  final double? height;
  final bool isLoading;

  const MyBorderButton({
    super.key,
    required this.title,
    this.borderColor,
    this.height,
    this.margin,
    required this.function,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Container(
        alignment: Alignment.center,
        margin: margin,
        height: height ?? 55,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(10),
          border: Border.all(color: borderColor ?? AppColor.blackColor),
        ),
        child: isLoading
            ? SpinKitThreeBounce(size: 20, color: borderColor)
            : AppText(
                text: title,
                color: borderColor ?? AppColor.blackColor,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
      ),
    );
  }
}

class MyBorderButtonWithIcon extends StatelessWidget {
  final String title;
  final Color? borderColor;
  final EdgeInsetsGeometry? margin;
  final Function function;
  final double? height;
  final bool isLoading;
  final String iconPath;

  const MyBorderButtonWithIcon({
    super.key,
    required this.title,
    this.borderColor,
    this.height,
    this.margin,
    required this.iconPath,
    required this.function,
    this.isLoading = false,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Container(
        alignment: Alignment.center,
        margin: margin,
        height: height ?? 55,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16), // Add horizontal padding
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor ?? AppColor.blackColor,
            width: 1.5,
          ),
        ),
        child: isLoading
            ? SpinKitThreeBounce(size: 20, color: borderColor)
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(iconPath, height: 24, width: 24),
                  SizedBox(width: 20),
                  Flexible(
                    child: AppText(
                      text: title,
                      color: borderColor ?? AppColor.blackColor,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
