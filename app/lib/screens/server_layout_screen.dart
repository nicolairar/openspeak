// ignore_for_file: deprecated_member_use, unused_local_variable, unused_import

// server_layout_screen.dart

import 'package:app/widgets/welcome_widget.dart';
import 'package:flutter/material.dart';
import '../widgets/server_layout_components.dart';
import '../widgets/message_input.dart';

String? selectedChannel;

class ServerLayoutScreen extends StatefulWidget {
  const ServerLayoutScreen({super.key});

  @override
  State<ServerLayoutScreen> createState() => _ServerLayoutScreenState();
}

class _ServerLayoutScreenState extends State<ServerLayoutScreen> {
  bool isServerCollapsed = false;
  bool showChannels = true;
  final List<String> openChats = [];

  String? selectedServer;

  final Map<String, List<String>> mockServers = {
    'OpenSpeak': ['general', 'random', 'voice-chat'],
    'GamingHub': ['chat-lounge', 'fps-voice', 'rpg-chat'],
  };

  final Map<String, List<String>> mockMessages = {
    'general': ['Welcome to general!', 'How are you today?'],
    'random': ['Random talks start here...'],
    'voice-chat': ['Voice chat text channel.'],
    'chat-lounge': ['Grab a virtual coffee!'],
    'fps-voice': ['Boom headshot!'],
    'rpg-chat': ['Roll a d20!'],
  };

  void toggleChat(String channel) {
    setState(() {
      if (openChats.contains(channel)) {
        openChats.remove(channel);
        if (selectedChannel == channel) {
          selectedChannel = null;
        }
      } else {
        openChats.add(channel);
        selectedChannel = channel;
      }
    });
  }

  void sendMessage(String channel, String message) {
    setState(() {
      mockMessages[channel]?.insert(0, message);
    });
  }

  final List<double> chatWidths = [1.0];

  @override
  Widget build(BuildContext context) {
    final totalChats = openChats.length;
    final totalFlex = totalChats == 0 ? 1 : totalChats;
    if (chatWidths.length != totalChats) {
      chatWidths.clear();
      chatWidths.addAll(List.filled(totalChats, 1.0 / totalChats));
    }

    if (chatWidths.isNotEmpty) {
      double sum = chatWidths.reduce((a, b) => a + b);
      if (sum != 1.0) {
        for (int i = 0; i < chatWidths.length; i++) {
          chatWidths[i] /= sum;
        }
      }
    }

    final double usedWidth =
        (isServerCollapsed ? 60 : 250) +
        (selectedServer != null && showChannels ? 250 : 0);
    final double availableWidth = MediaQuery.of(context).size.width - usedWidth;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        elevation: 0,
        toolbarHeight: 42,
        titleSpacing: 12,
        title: Row(
          children: [
            const Icon(Icons.tag, size: 18, color: Colors.white70),
            const SizedBox(width: 6),
            Text(
              'OpenSpeak',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 18),
            onPressed: () {},
            tooltip: 'Search',
          ),
          IconButton(
            icon: const Icon(Icons.person_add_alt_1, size: 18),
            onPressed: () {},
            tooltip: 'Invite',
          ),
          IconButton(
            icon: const Icon(Icons.settings, size: 18),
            onPressed: () {},
            tooltip: 'Settings',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isServerCollapsed ? 60 : 250,
                child: ServersColumn(
                  servers: mockServers.keys.toList(),
                  selected: selectedServer,
                  onSelect: (server) {
                    setState(() {
                      selectedServer = server;
                      showChannels = true;
                    });
                  },
                  header:
                      isServerCollapsed
                          ? IconButton(
                            icon: const Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.white,
                            ),
                            onPressed:
                                () => setState(() => isServerCollapsed = false),
                          )
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Servers',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.keyboard_arrow_left,
                                  color: Colors.white,
                                ),
                                onPressed:
                                    () => setState(
                                      () => isServerCollapsed = true,
                                    ),
                              ),
                            ],
                          ),
                  collapsed: isServerCollapsed,
                ),
              ),

              if (selectedServer != null && showChannels)
                Container(
                  width: 250,
                  child: ChannelsColumn(
                    channels: mockServers[selectedServer]!,
                    selected: selectedChannel,
                    onSelect: (channel) => toggleChat(channel),
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Channels',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => setState(() => showChannels = false),
                        ),
                      ],
                    ),
                  ),
                ),

              ...List.generate(openChats.length, (index) {
                final chat = openChats[index];
                return GestureDetector(
                  onHorizontalDragUpdate:
                      index < openChats.length - 1
                          ? (details) {
                            setState(() {
                              final delta = details.delta.dx / availableWidth;
                              chatWidths[index] += delta;
                              chatWidths[index + 1] -= delta;
                              if (chatWidths[index] < 0.1)
                                chatWidths[index] = 0.1;
                              if (chatWidths[index + 1] < 0.1)
                                chatWidths[index + 1] = 0.1;
                            });
                          }
                          : null,
                  child: SizedBox(
                    width: availableWidth * chatWidths[index],
                    child: Column(
                      children: [
                        Expanded(
                          child: ChatColumn(
                            messages: mockMessages[chat] ?? [],
                            onSend: (msg) => sendMessage(chat, msg),
                            header: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              chat.contains('voice')
                                                  ? Icons.headset
                                                  : Icons.chat,
                                              size: 16,
                                              color: Colors.white70,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              '$chat chat',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          selectedServer ?? '',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white38,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                  onPressed: () => toggleChat(chat),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              if (openChats.isEmpty)
                SizedBox(
                  width: availableWidth,
                  height: MediaQuery.of(context).size.height,
                  child: WelcomeWidget(
                    onJoinOpenSpeak: () {
                      setState(() {
                        selectedServer = 'OpenSpeak';
                        showChannels = true;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
