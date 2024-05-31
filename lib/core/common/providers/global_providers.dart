import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder_app/core/services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) => StorageService());

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, bool>((ref) {
  final storageService = ref.read(storageServiceProvider);
  return ThemeModeNotifier(storageService);
});

class ThemeModeNotifier extends StateNotifier<bool> {
  final StorageService _storageService;
  ThemeModeNotifier(this._storageService) : super(true) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    state = await _storageService.getThemeMode();
  }

  void toggleThemeMode() {
    state = !state;
    _storageService.setThemeMode(state);
  }
}

final remindersProvider = StateNotifierProvider<RemindersNotifier, List<Map<String, dynamic>>>((ref) {
  final storageService = ref.read(storageServiceProvider);
  return RemindersNotifier(storageService);
});

class RemindersNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  final StorageService _storageService;
  RemindersNotifier(this._storageService) : super([]) {
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    state = await _storageService.getReminders();
  }

  void addReminder(Map<String, dynamic> reminder) {
    state = [...state, reminder];
    _storageService.setReminders(state);
  }

  void updateReminder(int index, Map<String, dynamic> reminder) {
    state = [...state]..[index] = reminder;
    _storageService.setReminders(state);
  }

  void updateReminders(List<Map<String, dynamic>> reminders) {
    state = reminders;
    _storageService.setReminders(state);
  }

  void removeReminder(int index) {
    state = [...state]..removeAt(index);
    _storageService.setReminders(state);
  }
}