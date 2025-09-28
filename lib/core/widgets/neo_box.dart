import 'package:flutter/material.dart';
import 'package:hipster/core/constants/app_colors.dart';

class NeuBox extends StatelessWidget {
  final Widget child;
  final Function function;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final bool needOrange;
  const NeuBox({
    super.key,
    required this.child,
    required this.function,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius,
    this.needOrange = true,
    this.margin,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          // border: Border.all(  color: const Color.fromARGB(255, 228, 117, 83).withValues(alpha: .5),),
          borderRadius: borderRadius ?? BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColor.blackColor,
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(1, 1),
            ),
            BoxShadow(
              color: Colors.white,
              blurRadius: 15,
              offset: Offset(-5, -5),
            ),
            if (needOrange) ...[
              BoxShadow(
                color: Colors.orangeAccent.withValues(alpha: .5),
                blurRadius: 3,
                offset: Offset(-1, -1),
              ),
            ],
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
