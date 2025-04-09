import 'package:bills_calculator/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bills_calculator/theme/theme.dart';
import 'package:light_dark_theme_toggle/light_dark_theme_toggle.dart';

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
            fontSize: GlobalThemeVariables.h1,
          )),
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
                if (title == 'Adaugă factură' || title == 'Add bill') {
                  Navigator.pop(context);
                }
                if (title == 'Adaugă facturi după existente' ||
                    title == 'Edit existing bills') {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              },
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Image.asset(
                "assets/images/wide_house_euro.png",
              ),
            ),
      centerTitle: true,
      actions: <Widget>[
        LightDarkThemeToggle(
          value: Provider.of<ThemeProvider>(context, listen: false)
                  .themeData
                  .brightness ==
              Brightness.light,
          // Initial value (false for dark, true for light)
          onChanged: (bool value) {
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          },
          size: GlobalThemeVariables.h1,
          themeIconType: ThemeIconType.expand,
          color: Theme.of(context).iconTheme.color,
          tooltip: 'Toggle Theme',
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        ),
        Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
