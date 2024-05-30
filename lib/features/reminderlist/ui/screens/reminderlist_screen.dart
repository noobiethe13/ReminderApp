import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/core/common/theme/palette.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/providers/global_providers.dart';
import 'package:reminder_app/core/Navigator/app_navigator.dart';

class ReminderListScreen extends ConsumerStatefulWidget {
  const ReminderListScreen({super.key});

  @override
  ConsumerState<ReminderListScreen> createState() => _ReminderListScreen();
}

class _ReminderListScreen extends ConsumerState<ReminderListScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Your Reminders',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 25,
            color: Palette.lightColorScheme.onPrimary,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(themeModeProvider.notifier).state =
              !ref.read(themeModeProvider);
              },
            icon: Icon(
              isDarkMode ? CupertinoIcons.sun_max : CupertinoIcons.moon,
              size: 25,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {AppNavigator.navigateToCreateReminderScreen(context);},
        backgroundColor: isDarkMode
            ? Palette.darkColorScheme.primary
            : Palette.lightColorScheme.primary,
        shape: const CircleBorder(),
        child: const Icon(CupertinoIcons.add, size: 25),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: const Column(
        children: [],
      ),
    );
  }
}