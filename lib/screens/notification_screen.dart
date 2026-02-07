import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notification"), centerTitle: true, leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context))),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("Common", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          _buildSwitch("General Notification", true),
          _buildSwitch("Sound", false),
          _buildSwitch("Vibrate", true),
          const Divider(),
          const Text("System & services update", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          _buildSwitch("App updates", false),
          _buildSwitch("Bill Reminder", true),
          _buildSwitch("Promotion", true),
        ],
      ),
    );
  }

  Widget _buildSwitch(String title, bool val) => SwitchListTile(
    title: Text(title), value: val, onChanged: (v) {}, activeColor: Colors.blue,
  );
}