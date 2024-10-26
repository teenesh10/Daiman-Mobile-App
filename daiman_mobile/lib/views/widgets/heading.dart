import 'package:flutter/material.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    this.onPressed,
    this.textColor,
    this.showActionButton = false,
    required this.title,
    this.buttonTitle = "View All",
  });

  final Color? textColor;
  final bool showActionButton;
  final String title, buttonTitle;
  final void Function()? onPressed; // Fixed the `void Function()` type

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Added spacing
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(color: textColor), // Fixed the text style
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (showActionButton)
          TextButton(
            onPressed: onPressed,
            child: Text(buttonTitle),
          ),
      ],
    );
  }
}
