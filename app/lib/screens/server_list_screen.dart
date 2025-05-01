import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'chat_screen.dart';

class ServerListScreen extends StatelessWidget {
  const ServerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.user;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      drawer: NavigationDrawer(
        children: [
          const DrawerHeader(
            child: Text('OpenSpeak Menu', style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          ListTile(
            leading: const Icon(Icons.chat, color: Colors.white),
            title: const Text('Chat', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChatScreen()));
            },
          ),
          if (user?.role == 'admin')
            ListTile(
              leading: const Icon(Icons.admin_panel_settings, color: Colors.white),
              title: const Text('Admin Panel', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navigator push verso AdminScreen
              },
            ),
        ],
      ),
      appBar: AppBar(
        title: Text('Servers for ${user?.username ?? 'User'}'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome to OpenSpeak 👋",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Here are your servers. Click to join and chat!",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildServerCard(context, "OpenSpeak", "The public server", Icons.public),
                  // Aggiungi altri server qui
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildServerCard(BuildContext context, String name, String description, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blueAccent),
              const SizedBox(width: 8),
              Text(name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(color: Colors.white70)),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChatScreen()));
              },
              icon: const Icon(Icons.login, size: 16),
              label: const Text("Enter"),
            ),
          )
        ],
      ),
    );
  }
}
