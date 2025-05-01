import 'package:flutter/material.dart';

class WelcomeWidget extends StatefulWidget {
  final VoidCallback onJoinOpenSpeak;

  const WelcomeWidget({
    super.key,
    required this.onJoinOpenSpeak,
  });

  @override
  State<WelcomeWidget> createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.white24),
          const SizedBox(height: 16),
          const Text(
            'Welcome to OpenSpeak',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select a channel or server to get started.\nJoin the community, explore chats, or invite friends!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
          const SizedBox(height: 24),
          MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            cursor: SystemMouseCursors.click,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 120),
              scale: _isHovered ? 1.05 : 1.0,
              child: Material(
                color: Colors.blueGrey[700],
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: widget.onJoinOpenSpeak,
                  borderRadius: BorderRadius.circular(10),
                  splashColor: Colors.blueAccent.withOpacity(0.2),
                  highlightColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: const Text(
                      'Explore OpenSpeak Server',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
