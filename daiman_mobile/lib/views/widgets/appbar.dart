import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leadingOnPressed,
    this.showBackArrows = false,
    required Color backgroundColor,
  }): _backgroundColor = backgroundColor;

  final Widget? title;
  final bool showBackArrows;
  final IconData? leadingIcon;
  final List<Widget>? actions; // Fixed typo: "acions" to "actions"
  final VoidCallback? leadingOnPressed;
  final Color _backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: showBackArrows
            ? IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_left),
              )
            : leadingIcon != null
                ? IconButton(
                    onPressed: leadingOnPressed,
                    icon: Icon(leadingIcon),
                  )
                : null,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      AppBar().preferredSize.height); // Use default AppBar height
}
