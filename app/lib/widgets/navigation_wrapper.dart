// ignore_for_file: unused_import
//navigation_wrapper.dart

import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../screens/admin_screen.dart';
import '../screens/chat_screen.dart';

class NavigationWrapper extends StatelessWidget {
  const NavigationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenSpeak'),
        backgroundColor: Colors.black,
      ),
      drawer: NavigationDrawer(
        children: [
          const DrawerHeader(
            child: Text('Menu', style: TextStyle(color: Colors.white)),
          ),
          if (user?.role == 'admin')
            ListTile(
              title: const Text('Admin Dashboard', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminScreen()));
              },
            ),
          ListTile(
            title: const Text('Chat', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChatScreen()));
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Text(
          'Welcome ${user?.username ?? 'User'}!',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
