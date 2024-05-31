import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledDate) async {
    final tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzScheduledDate,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> checkAndSendNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    String? remindersJson = prefs.getString('reminders');
    if (remindersJson != null) {
      List<dynamic> remindersList = jsonDecode(remindersJson);
      for (var reminder in remindersList) {
        Map<String, dynamic> reminderMap = reminder as Map<String, dynamic>;
        String priority = reminderMap['priority'];
        DateTime dateTime = DateTime.parse(reminderMap['date']);
        TimeOfDay timeOfDay = TimeOfDay(
          hour: int.parse(reminderMap['time'].split(":")[0]),
          minute: int.parse(reminderMap['time'].split(":")[1]),
        );

        DateTime reminderDateTime = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          timeOfDay.hour,
          timeOfDay.minute,
        );

        DateTime now = DateTime.now();

        if (reminderDateTime.isAfter(now)) {
          Duration difference = reminderDateTime.difference(now);

          if (priority == 'High') {
            if (difference <= const Duration(hours: 1) && difference > const Duration(minutes: 10)) {
              await scheduleNotification(
                  reminderMap['id'],
                  reminderMap['title'],
                  reminderMap['description'],
                  reminderDateTime.subtract(const Duration(minutes: 10)));
            }
          } else if (priority == 'Medium') {
            if (difference <= const Duration(minutes: 30) && difference > const Duration(minutes: 10)) {
              await scheduleNotification(
                  reminderMap['id'],
                  reminderMap['title'],
                  reminderMap['description'],
                  reminderDateTime.subtract(const Duration(minutes: 10)));
            }
          } else if (priority == 'Low') {
            if (difference <= const Duration(minutes: 15)) {
              await scheduleNotification(
                  reminderMap['id'],
                  reminderMap['title'],
                  reminderMap['description'],
                  reminderDateTime.subtract(const Duration(minutes: 15)));
            }
          }

          if (difference <= const Duration(seconds: 0)) {
            await scheduleNotification(
                reminderMap['id'],
                reminderMap['title'],
                reminderMap['description'],
                reminderDateTime);
          }
        }
      }
    }
  }
}