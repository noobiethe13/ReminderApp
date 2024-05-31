import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reminder_app/core/common/theme/palette.dart';
import 'package:intl/intl.dart';
import '../../../../core/common/providers/global_providers.dart';

class CreateReminderScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? prefillData;

  const CreateReminderScreen({super.key, this.prefillData});

  @override
  _CreateReminderScreenState createState() => _CreateReminderScreenState();
}

class _CreateReminderScreenState extends ConsumerState<CreateReminderScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedPriority = 'Medium';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.prefillData != null) {
      _titleController.text = widget.prefillData!['title'];
      _descriptionController.text = widget.prefillData!['description'];
      _selectedPriority = widget.prefillData!['priority'];
      _selectedDate = widget.prefillData!['date'];
      _selectedTime = widget.prefillData!['time'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Create A Reminder",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: Palette.lightColorScheme.onPrimary,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.multiply,
            size: 25,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Title",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Enter title here',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Add Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Enter description here',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  "Set Priority",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                DropdownButton<String>(
                  value: _selectedPriority,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPriority = newValue!;
                    });
                  },
                  items: <String>['High', 'Medium', 'Low']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "Select Date",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 24),
                  label: const Text(
                    "Select Date",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
                const Spacer(),
                Text(
                  _selectedDate == null
                      ? 'No date chosen'
                      : DateFormat.yMMMd().format(_selectedDate!),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "Set Time",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.access_time, size: 24),
                  label: const Text(
                    "Select Time",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null && picked != _selectedTime) {
                      setState(() {
                        _selectedTime = picked;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
                const Spacer(),
                Text(
                  _selectedTime == null
                      ? 'No time chosen'
                      : _selectedTime!.format(context),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 130),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 50,
                  width: 170,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_titleController.text.isEmpty ||
                          _descriptionController.text.isEmpty ||
                          _selectedDate == null ||
                          _selectedTime == null) {
                        final snackBar = SnackBar(
                          content: Text(
                            'Please fill all fields!',
                            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                          ),
                          backgroundColor: isDarkMode
                              ? Palette.darkColorScheme.error
                              : Palette.lightColorScheme.error,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        Map<String, dynamic> newReminder = {
                          'title': _titleController.text,
                          'description': _descriptionController.text,
                          'priority': _selectedPriority,
                          'date': _selectedDate,
                          'time': _selectedTime,
                        };
                        if (widget.prefillData != null) {
                          int index = ref.read(remindersProvider).indexOf(widget.prefillData!);
                          ref.read(remindersProvider.notifier).updateReminder(index, newReminder);
                        } else {
                          ref.read(remindersProvider.notifier).addReminder(newReminder);
                        }
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? Palette.darkColorScheme.primary
                          : Palette.lightColorScheme.primary,
                    ),
                    child: const Text(
                      "Save Reminder",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 170,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.lightColorScheme.onSecondary,
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
