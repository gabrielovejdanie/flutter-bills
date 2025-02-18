import 'package:bills_calculator/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      title: Text(title,
          style: const TextStyle(
            fontFamily: 'Alexandria',
            fontSize: 18,
          )),
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Image.asset(
                "assets/images/bills_logo_orange.png",
              ),
            ),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon: const Icon(Icons.lightbulb))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
