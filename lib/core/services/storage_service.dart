import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class StorageService {
  static const String _themeModeKey = 'themeMode';
  static const String _remindersKey = 'reminders';

  Future<bool> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeModeKey) ?? true;
  }

  Future<void> setThemeMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeModeKey, value);
  }

  Future<List<Map<String, dynamic>>> getReminders() async {
    final prefs = await SharedPreferences.getInstance();
    String? remindersJson = prefs.getString(_remindersKey);
    if (remindersJson != null) {
      List<dynamic> remindersList = jsonDecode(remindersJson);
      return remindersList.map((e) => _mapFromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  Future<void> setReminders(List<Map<String, dynamic>> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    String remindersJson = jsonEncode(reminders.map((e) => _mapToJson(e)).toList());
    await prefs.setString(_remindersKey, remindersJson);
  }

  Map<String, dynamic> _mapToJson(Map<String, dynamic> reminder) {
    return {
      'title': reminder['title'],
      'description': reminder['description'],
      'priority': reminder['priority'],
      'date': reminder['date']?.toIso8601String(),
      'time': reminder['time'] != null ? '${reminder['time'].hour}:${reminder['time'].minute}' : null,
    };
  }

  Map<String, dynamic> _mapFromJson(Map<String, dynamic> json) {
    return {
      'title': json['title'],
      'description': json['description'],
      'priority': json['priority'],
      'date': json['date'] != null ? DateTime.parse(json['date']) : null,
      'time': json['time'] != null
          ? TimeOfDay(
        hour: int.parse(json['time'].split(":")[0]),
        minute: int.parse(json['time'].split(":")[1]),
      )
          : null,
    };
  }
}