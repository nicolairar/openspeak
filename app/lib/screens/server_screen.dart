import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'chat_screen.dart';
import 'admin_screen.dart';

class ServerScreen extends StatelessWidget {
  final String serverName;

  const ServerScreen({super.key, required this.serverName});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(serverName),
        backgroundColor: Colors.black,
      ),
      body: Row(
        children: [
          Container(
            width: 250,
            color: Colors.grey[850],
            child: ListView(
              children: [
                const DrawerHeader(
                  child: Text('Channels', style: TextStyle(color: Colors.white)),
                ),
                const ListTile(
                  leading: Icon(Icons.chat, color: Colors.white),
                  title: Text('💬 General', style: TextStyle(color: Colors.white)),
                ),
                const ListTile(
                  leading: Icon(Icons.mic, color: Colors.white),
                  title: Text('🔊 Voice Lounge', style: TextStyle(color: Colors.white)),
                ),
                if (user?.role == 'admin')
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings, color: Colors.white),
                    title: const Text('Admin Panel', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AdminScreen()));
                    },
                  ),
              ],
            ),
          ),
          const Expanded(child: ChatScreen()),
        ],
      ),
    );
  }
}
