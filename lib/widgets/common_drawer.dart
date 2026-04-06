import 'package:chess_position_binder/i18n/strings.g.dart';
import 'package:chess_position_binder/providers/dark_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommonDrawer extends ConsumerStatefulWidget {
  const CommonDrawer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommonDrawerState();
}

class _CommonDrawerState extends ConsumerState<CommonDrawer> {
  @override
  Widget build(BuildContext context) {
    final inDarkMode = ref.watch(darkThemeProvider);
    final darkModeNotifier = ref.read(darkThemeProvider.notifier);
    return Drawer(
      child: Column(
        spacing: 15.0,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DrawerHeader(child: Text(t.options.title)),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10.0,
            children: [
              Text(t.options.dark_mode_label),
              Switch(
                value: inDarkMode,
                onChanged: (newValue) => darkModeNotifier.toggle(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
