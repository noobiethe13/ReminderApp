import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder_app/core/common/theme/palette.dart';
import '../../../../core/common/providers/global_providers.dart';
import 'package:reminder_app/core/Navigator/app_navigator.dart';
import 'package:intl/intl.dart';

class ReminderListScreen extends ConsumerStatefulWidget {
  const ReminderListScreen({super.key});

  @override
  ConsumerState<ReminderListScreen> createState() => _ReminderListScreen();
}

class _ReminderListScreen extends ConsumerState<ReminderListScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);
    final reminders = ref.watch(remindersProvider);

    List<Map<String, dynamic>> sortedReminders = List.from(reminders)
      ..sort((a, b) {
        int priorityComparison = _priorityValue(a['priority']).compareTo(_priorityValue(b['priority']));
        if (priorityComparison != 0) return priorityComparison;

        DateTime aDateTime = DateTime(a['date'].year, a['date'].month, a['date'].day, a['time'].hour, a['time'].minute);
        DateTime bDateTime = DateTime(b['date'].year, b['date'].month, b['date'].day, b['time'].hour, b['time'].minute);

        return aDateTime.compareTo(bDateTime);
      });

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
        onPressed: () {
          AppNavigator.navigateToCreateReminderScreen(context);
        },
        backgroundColor: isDarkMode
            ? Palette.darkColorScheme.primary
            : Palette.lightColorScheme.primary,
        shape: const CircleBorder(),
        child: const Icon(CupertinoIcons.add, size: 25),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: sortedReminders.isEmpty
          ? Center(
        child: Text(
          'Create a reminder to get started!',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: sortedReminders.length,
        itemBuilder: (context, index) {
          final reminder = sortedReminders[index];
          final reminderDate = reminder['date'];
          final reminderTime = reminder['time'];
          final now = DateTime.now();
          final isToday = reminderDate.year == now.year &&
              reminderDate.month == now.month &&
              reminderDate.day == now.day;

          return Card(
            color: isDarkMode ? Colors.white70 : Colors.grey[850],
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                reminder['title'],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: isDarkMode ? Colors.black : Colors.white,
                ),
              ),
              subtitle: Text(
                isToday
                    ? 'Today at ${reminderTime.format(context)}'
                    : '${DateFormat.yMMMd().format(reminderDate)} at ${reminderTime.format(context)}',
                style: TextStyle(
                  color: isDarkMode ? Colors.black : Colors.white,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      AppNavigator.navigateToCreateReminderScreen(
                        context,
                        prefillData: reminder,
                      );
                    },
                    color: isDarkMode ? Colors.black : Colors.white,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        reminders.removeAt(index);
                        ref.read(remindersProvider.notifier).state =
                            reminders;
                      });
                    },
                    color: isDarkMode ? Colors.black : Colors.white,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  int _priorityValue(String priority) {
    switch (priority) {
      case 'High':
        return 0;
      case 'Medium':
        return 1;
      case 'Low':
        return 2;
      default:
        return 3;
    }
  }
}
