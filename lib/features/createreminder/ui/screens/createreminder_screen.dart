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

  void _saveReminder() {
    final title = _titleController.text;
    final description = _descriptionController.text;
    if (title.isEmpty || description.isEmpty || _selectedDate == null || _selectedTime == null) {
      // You can show an error message here if you want
      return;
    }

    final newReminder = {
      'title': title,
      'description': description,
      'priority': _selectedPriority,
      'date': _selectedDate,
      'time': _selectedTime,
    };

    if (widget.prefillData != null) {
      final reminders = ref.read(remindersProvider.notifier).state;
      final index = reminders.indexOf(widget.prefillData!);
      reminders[index] = newReminder;
      ref.read(remindersProvider.notifier).state = List.from(reminders);
    } else {
      ref.read(remindersProvider.notifier).update((state) => [...state, newReminder]);
    }

    // Pop the screen after saving
    Navigator.pop(context);
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
          icon: Icon(
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
            Text(
              "Add Title",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter title here',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Add Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Enter description here',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Text(
                  "Set Priority",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Spacer(),
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
            SizedBox(height: 24),
            Text(
              "Select Date",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.calendar_today, size: 24),
                  label: Text(
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
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
                Spacer(),
                Text(
                  _selectedDate == null
                      ? 'No date chosen'
                      : DateFormat.yMMMd().format(_selectedDate!),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              "Set Time",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.access_time, size: 24),
                  label: Text(
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
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
                Spacer(),
                Text(
                  _selectedTime == null
                      ? 'No time chosen'
                      : _selectedTime!.format(context),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 130),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 50,
                  width: 170,
                  child: ElevatedButton(
                    onPressed: _saveReminder,
                    child: Text(
                      "Save Reminder",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode
                          ? Palette.darkColorScheme.primary
                          : Palette.lightColorScheme.primary,
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
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.lightColorScheme.onSecondary,
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
