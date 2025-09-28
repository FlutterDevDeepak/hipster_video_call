import 'package:flutter/material.dart';
import 'package:hipster/core/constants/app_colors.dart';
import 'package:hipster/core/widgets/app_text.dart';

class MyCommonExpainsonTile extends StatelessWidget {
  final String title;
  final List<Widget> childrenItem;
  const MyCommonExpainsonTile({
    super.key,
    required this.title,
    required this.childrenItem,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
      child: ExpansionTile(
        iconColor: Colors.black,
        collapsedIconColor: Colors.black,
        enableFeedback: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColor.blackColor),
          borderRadius: BorderRadius.circular(10),
        ),
        collapsedShape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColor.blackColor),
          borderRadius: BorderRadius.circular(10),
        ),
        title: AppText(text: title, fontWeight: FontWeight.bold),

        children: childrenItem,
      ),
    );
  }
}
