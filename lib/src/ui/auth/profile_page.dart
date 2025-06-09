import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final userProv = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Email: ${user?.email ?? ''}', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 24),
          const Text('Preferred Stotra Language:', style: TextStyle(fontSize: 16)),
          DropdownButton<String>(
            value: userProv.preferredLanguage,
            items: ['english', 'hindi', 'telugu']
                .map((lang) => DropdownMenuItem(value: lang, child: Text(lang.toUpperCase())))
                .toList(),
            onChanged: (lang) => userProv.updatePreferredLanguage(lang!),
          ),
          const Spacer(),
          Center(
            child: ElevatedButton(
              onPressed: () {
                auth.signOut();
                Navigator.pushReplacementNamed(context, '/signin');
              },
              child: const Text('Sign Out'),
            ),
          ),
        ]),
      ),
    );
  }
}
