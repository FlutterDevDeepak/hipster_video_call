
import 'package:flutter/material.dart';
import 'package:hipster/core/constants/app_colors.dart';

import 'app_text.dart';
class HeaderWidget extends StatelessWidget {
  final String title;
  const HeaderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: AppColor.blackColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: AppText(
            text: title,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        Expanded(child: Container(height: 1, color: AppColor.blackColor)),
      ],
    );
  }
}
