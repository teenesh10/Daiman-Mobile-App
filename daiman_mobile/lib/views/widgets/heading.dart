import 'package:flutter/material.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    this.onPressed,
    this.textColor,
    this.showActionButton = false,
    required this.title,
    this.buttonTitle = "View All",
    this.headingStyle = 'large', // New parameter for heading size
  });

  final Color? textColor;
  final bool showActionButton;
  final String title, buttonTitle;
  final void Function()? onPressed; // Fixed the `void Function()` type
  final String headingStyle; // New parameter to specify heading size

  @override
  Widget build(BuildContext context) {
    // Get the text theme from the context
    final textTheme = Theme.of(context).textTheme;

    // Set the appropriate text style based on headingStyle
    TextStyle headingTextStyle;
    switch (headingStyle) {
      case 'medium':
        headingTextStyle = textTheme.displayMedium!;
        break;
      case 'small':
        headingTextStyle = textTheme.displaySmall!;
        break;
      case 'large':
      default:
        headingTextStyle = textTheme.displayLarge!;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Added spacing
      children: [
        Expanded(
          child: Text(
            title,
            style: headingTextStyle.copyWith(color: textColor), // Apply the text style
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
