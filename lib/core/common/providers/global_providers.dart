import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeModeProvider = StateProvider<bool>((ref) => true); //APP THEME MODE
final remindersProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []); //LIST OF REMINDERS

