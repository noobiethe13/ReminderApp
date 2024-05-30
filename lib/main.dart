import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder_app/core/common/theme/palette.dart';
import 'package:reminder_app/features/reminderlist/ui/screens/reminderlist_screen.dart';

import 'core/common/providers/global_providers.dart';


void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Palette.lightTheme,
      darkTheme: Palette.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const ReminderListScreen(),
    );
  }
}


