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
  }) : _backgroundColor = backgroundColor;

  final Widget? title;
  final bool showBackArrows;
  final IconData? leadingIcon;
  final List<Widget>? actions;
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
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white, // Set back arrow color to white
                ),
              )
            : leadingIcon != null
                ? IconButton(
                    onPressed: leadingOnPressed,
                    icon: Icon(
                      leadingIcon,
                      color: Colors.white, // Set custom leading icon color to white
                    ),
                  )
                : null,
        title: title,
        actions: actions?.map((action) {
          if (action is IconButton) {
            return IconButton(
              icon: IconTheme(
                data: const IconThemeData(color: Colors.white), // Set action icon color to white
                child: action.icon,
              ),
              onPressed: action.onPressed,
            );
          }
          return action;
        }).toList(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Use default AppBar height
}
