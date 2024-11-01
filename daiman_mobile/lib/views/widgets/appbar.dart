import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leadingOnPressed,
    this.showBackArrows = false,
    this.titleColor = Colors.black, // Default to black
    this.leadingIconColor = Colors.black, // Default to black
  });

  final Widget? title;
  final bool showBackArrows;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final Color titleColor;
  final Color leadingIconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: showBackArrows
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back,
                    color: leadingIconColor), // Use dynamic color
              )
            : leadingIcon != null
                ? IconButton(
                    onPressed: leadingOnPressed,
                    icon: Icon(leadingIcon,
                        color: leadingIconColor), // Use dynamic color
                  )
                : null,
        title: title != null
            ? DefaultTextStyle(
                style: TextStyle(color: titleColor), // Use dynamic color
                child: title!,
              )
            : null,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
