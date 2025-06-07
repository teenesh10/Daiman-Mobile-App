import 'package:flutter/material.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    this.onPressed,
    this.textColor,
    this.showActionButton = false,
    required this.title,
    this.buttonTitle = "View All",
    this.headingStyle = 'large', 
  });

  final Color? textColor;
  final bool showActionButton;
  final String title, buttonTitle;
  final void Function()? onPressed; 
  final String headingStyle; 

  @override
  Widget build(BuildContext context) {

    TextStyle headingTextStyle;
    switch (headingStyle) {
      case 'medium':
        headingTextStyle = TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        );
        break;
      case 'small':
        headingTextStyle = TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        );
        break;
      case 'large':
      default:
        headingTextStyle = TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, 
      children: [
        Expanded(
          child: Text(
            title,
            style: headingTextStyle.copyWith(
                color: textColor), 
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
