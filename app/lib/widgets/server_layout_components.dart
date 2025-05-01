//server_layout_components.dart
import 'package:flutter/material.dart';
import '../screens/home_screen.dart'; // Per MessageInput

class ServersColumn extends StatelessWidget {
  final List<String> servers;
  final String? selected;
  final void Function(String) onSelect;
  final Widget header;
  final bool collapsed;

  const ServersColumn({
    super.key,
    required this.servers,
    required this.selected,
    required this.onSelect,
    required this.header,
    this.collapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[900],
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.all(12), child: header),
          const Divider(color: Colors.white12),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: servers.map((server) {
                return collapsed
                    ? Tooltip(
                        message: server,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: selected == server
                                ? Colors.blueAccent.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.public,
                                  color: Colors.white70,
                                ),
                                onPressed: () => onSelect(server),
                                splashRadius: 24,
                                padding: EdgeInsets.zero,
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: AnimatedOpacity(
                                  opacity: selected == server ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        tileColor: selected == server
                            ? Colors.blueAccent.withOpacity(0.3)
                            : Colors.transparent,
                        leading: Icon(
                          Icons.public,
                          color: selected == server
                              ? Colors.blueAccent
                              : Colors.white70,
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                server,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: selected == server
                                      ? Colors.white
                                      : Colors.white70,
                                  fontWeight: selected == server
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: selected == server
                                  ? Container(
                                      key: const ValueKey(true),
                                      margin: const EdgeInsets.only(left: 6),
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                  : const SizedBox(
                                      key: ValueKey(false),
                                      width: 8,
                                      height: 8,
                                    ),
                            ),
                          ],
                        ),
                        hoverColor: Colors.blueGrey[800],
                        selected: selected == server,
                        onTap: () => onSelect(server),
                      );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ChannelsColumn extends StatelessWidget {
  final List<String> channels;
  final String? selected;
  final void Function(String) onSelect;
  final Widget header;

  const ChannelsColumn({
    super.key,
    required this.channels,
    required this.selected,
    required this.onSelect,
    required this.header,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[900],
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.all(12), child: header),
          const Divider(color: Colors.white12),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: channels.map((channel) {
                return ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  tileColor: selected == channel
                      ? Colors.blueAccent.withOpacity(0.3)
                      : Colors.transparent,
                  hoverColor: Colors.blueGrey[800],
                  leading: Icon(
                    channel.contains('voice') ? Icons.headset : Icons.chat,
                    color: selected == channel
                        ? Colors.blueAccent
                        : Colors.white70,
                  ),
                  title: Text(
                    channel,
                    style: TextStyle(
                      color:
                          selected == channel ? Colors.white : Colors.white70,
                      fontWeight: selected == channel
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  selected: selected == channel,
                  onTap: () => onSelect(channel),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatColumn extends StatelessWidget {
  final List<String> messages;
  final Widget header;
  final void Function(String) onSend;

  const ChatColumn({
    super.key,
    required this.messages,
    required this.header,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.all(12), child: header),
          const Divider(color: Colors.white12),
          Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.all(16),
              children: messages.map((msg) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[800],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "User",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        msg,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          MessageInput(onSend: onSend),
        ],
      ),
    );
  }
}
