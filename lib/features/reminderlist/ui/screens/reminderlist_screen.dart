import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reminder_app/core/common/theme/palette.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/common/providers/global_providers.dart';

class ReminderListScreen extends StatelessWidget {
  const ReminderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isDarkMode = ref.watch(themeModeProvider);

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Your Reminders',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: isDarkMode
                    ? Palette.darkColorScheme.onPrimary
                    : Palette.lightColorScheme.onPrimary,
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
            onPressed: () {},
            child: Icon(CupertinoIcons.add, size: 25),
            backgroundColor: isDarkMode
                ? Palette.lightColorScheme.primary
                : Palette.darkColorScheme.primary,
            shape: CircleBorder(),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: Column(
            children: [],
          ),
        );
      },
    );
  }
}