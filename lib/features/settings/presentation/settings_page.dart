import 'package:flutter/material.dart';
import 'package:streakdemo/core/services/notification_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = false;
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    // In a real app, you would load these from persistent storage
    // For now, we'll use dummy values
    setState(() {
      _notificationsEnabled = true; // Assume enabled by default for demonstration
      _selectedTime = const TimeOfDay(hour: 9, minute: 0); // Default to 9:00 AM
    });
  }

  void _toggleNotifications(bool value) async {
    setState(() {
      _notificationsEnabled = value;
    });
    if (value) {
      _scheduleDailyReminder();
    } else {
      await NotificationService().cancelAllNotifications();
    }
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      if (_notificationsEnabled) {
        _scheduleDailyReminder();
      }
    }
  }

  void _scheduleDailyReminder() {
    NotificationService().scheduleDailyNotification(
      id: 0,
      title: 'Daily Quote Reminder',
      body: 'Time for your daily dose of positivity!',
      time: _selectedTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Daily Reminders'),
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
          ),
          ListTile(
            title: const Text('Reminder Time'),
            subtitle: Text(_selectedTime.format(context)),
            onTap: _selectTime,
          ),
        ],
      ),
    );
  }
}
