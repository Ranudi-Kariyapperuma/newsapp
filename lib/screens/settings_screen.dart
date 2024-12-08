import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  String selectedLanguage = 'English';
  bool isNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Mode
            ListTile(
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (bool value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
              ),
            ),
            const Divider(),

            // Language Selection
            ListTile(
              title: const Text('Language'),
              subtitle: Text(selectedLanguage),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () async {
                  final language = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        title: const Text('Select Language'),
                        children: <Widget>[
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context, 'English');
                            },
                            child: const Text('English'),
                          ),
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context, 'Spanish');
                            },
                            child: const Text('Spanish'),
                          ),
                          SimpleDialogOption(
                            onPressed: () {
                              Navigator.pop(context, 'French');
                            },
                            child: const Text('French'),
                          ),
                        ],
                      );
                    },
                  );
                  if (language != null) {
                    setState(() {
                      selectedLanguage = language;
                    });
                  }
                },
              ),
            ),
            const Divider(),

            // Notifications
            ListTile(
              title: const Text('Notifications'),
              trailing: Switch(
                value: isNotificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    isNotificationsEnabled = value;
                  });
                },
              ),
            ),
            const Divider(),

            // Reset Settings Button
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isDarkMode = false;
                    selectedLanguage = 'English';
                    isNotificationsEnabled = true;
                  });
                },
                child: const Text('Reset to Default'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}