import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: RadioGroup<ThemeMode>(
        groupValue: themeMode,
        onChanged: (value) {
          if (value != null) {
            ref.read(themeProvider.notifier).state = value;
          }
        },
        child: ListView(
          children: [
            const ListTile(
              leading: Icon(Icons.palette),
              title: Text('Theme'),
            ),

            const RadioListTile<ThemeMode>(
              title: Text('System default'),
              value: ThemeMode.system,
            ),

            const RadioListTile<ThemeMode>(
              title: Text('Light'),
              value: ThemeMode.light,
            ),

            const RadioListTile<ThemeMode>(
              title: Text('Dark'),
              value: ThemeMode.dark,
            ),
          ],
        ),
      ),
    );
  }
}