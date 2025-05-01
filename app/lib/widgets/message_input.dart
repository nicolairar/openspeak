import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageInput extends StatefulWidget {
  final void Function(String) onSend;

  const MessageInput({super.key, required this.onSend});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  DateTime? _lastMessageTime;

  bool isFloodBlocked = false;
  int _secondsRemaining = 0;
  Timer? _floodTimer;

  void _startFloodTimer() {
    setState(() {
      isFloodBlocked = true;
      _secondsRemaining = 15;
    });

    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 40,
        left: MediaQuery.of(context).size.width * 0.25,
        width: MediaQuery.of(context).size.width * 0.5,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                '🚫 Flood Detected: User Suppressed',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 3), () => entry.remove());

    _floodTimer?.cancel();
    _floodTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() => isFloodBlocked = false);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty || isFloodBlocked) return;

    final now = DateTime.now();
    if (_lastMessageTime != null &&
        now.difference(_lastMessageTime!) < const Duration(seconds: 1)) {
      _startFloodTimer();
      return;
    }

    widget.onSend(text);
    _controller
      ..text = ''
      ..selection = const TextSelection.collapsed(offset: 0);
    _focusNode.requestFocus();
    _lastMessageTime = now;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _floodTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          final isEnter = event.logicalKey == LogicalKeyboardKey.enter;
          final isShift = event.isShiftPressed;
          if (isEnter && !isShift) _send();
        }
      },
      child: Container(
        color: Colors.grey[850],
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: true,
                enabled: !isFloodBlocked,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isFloodBlocked ? Colors.grey[700] : Colors.transparent,
                  hintText: isFloodBlocked
                      ? 'Flood blocked... wait $_secondsRemaining s'
                      : 'Type a message...',
                  hintStyle: TextStyle(
                    color: isFloodBlocked ? Colors.red[300] : Colors.white54,
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            if (isFloodBlocked)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red[600],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${_secondsRemaining}s',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            IconButton(
              icon: Icon(
                Icons.send,
                color: isFloodBlocked ? Colors.grey : Colors.blueAccent,
              ),
              onPressed: isFloodBlocked ? null : _send,
            ),
          ],
        ),
      ),
    );
  }
}