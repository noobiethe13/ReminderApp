import 'package:flutter/material.dart';
import 'package:reminder_app/features/reminderlist/ui/screens/reminderlist_screen.dart';
import '../../features/createreminder/ui/screens/createreminder_screen.dart';

class AppNavigator{
  static void navigateToCreateReminderScreen(BuildContext context, {Map<String, dynamic>? prefillData}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateReminderScreen(prefillData: prefillData),
      ),
    );
  }

  static navigateToReminderListScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => const ReminderListScreen(),
      ),
    );
  }
}
