import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageInput extends StatefulWidget {
  final void Function(String) onSend;

  const MessageInput({super.key, required this.onSend});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  bool isFloodBlocked = false;
  int _secondsRemaining = 0;
  Timer? _floodTimer;
  final _messageTimestamps = <DateTime>[];

  late AnimationController _toastController;
  late Animation<Offset> _toastSlide;

  late Animation<double> _toastOpacity;
  @override
  void initState() {
    super.initState();

    _toastController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _toastSlide = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -1.5),
    ).animate(
      CurvedAnimation(parent: _toastController, curve: Curves.easeInOut),
    );

    _toastOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _toastController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _floodTimer?.cancel();
    _toastController.dispose();
    super.dispose();
  }

  void _startFloodTimer() {
  setState(() {
    isFloodBlocked = true;
    _secondsRemaining = 15;
  });

  _toastController.reset();
  _toastController.reverse(from: 1.0); // appare subito, visibile

  _floodTimer?.cancel();
  _floodTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (_secondsRemaining <= 1) {
      timer.cancel();
      setState(() {
        isFloodBlocked = false;
      });
    } else {
      setState(() => _secondsRemaining--);
    }
  });

  // Dopo 5 secondi → fadeout + slide-up
  Future.delayed(const Duration(seconds: 5), () {
    if (mounted) _toastController.forward(); // sparisce con fade + slide
  });
}


  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty || isFloodBlocked) return;

    final now = DateTime.now();
    _messageTimestamps.removeWhere(
      (timestamp) => now.difference(timestamp) > const Duration(seconds: 1),
    );

    if (_messageTimestamps.length >= 4) {
      _startFloodTimer();
      return;
    }

    _messageTimestamps.add(now);
    widget.onSend(text);

    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        RawKeyboardListener(
          focusNode:
              FocusNode(), // Important: not _focusNode to avoid reparent errors
          onKey: (event) {
            if (event is RawKeyDownEvent) {
              final isEnter = event.logicalKey == LogicalKeyboardKey.enter;
              final isShift = event.isShiftPressed;
              if (isEnter && !isShift) {
                _send();
              }
            }
          },
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    autofocus: true,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText:
                          isFloodBlocked
                              ? 'Suppressed $_secondsRemaining s...'
                              : 'Type a message...',
                      hintStyle: TextStyle(
                        color:
                            isFloodBlocked ? Colors.red[300] : Colors.white54,
                        fontSize: 13,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (isFloodBlocked)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      '$_secondsRemaining s',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
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
        ),

        if (isFloodBlocked)
  Positioned(
    top: -40,
    left: 0,
    right: 0,
    child: SlideTransition(
      position: _toastSlide,
      child: FadeTransition(
        opacity: _toastOpacity,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: const Text(
              '🚫 Flood Detected: User Suppressed',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ),
  )

      ],
    );
  }
}
