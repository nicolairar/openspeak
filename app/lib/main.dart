import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/server_layout_screen.dart';

void main() {
  runApp(const OpenSpeakApp());
}

class OpenSpeakApp extends StatelessWidget {
  const OpenSpeakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenSpeak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        colorScheme: ColorScheme.dark(
          primary: Colors.blueAccent,
          secondary: Colors.tealAccent,
        ),
      ),
      home: const ServerLayoutScreen(),
    );
  }
}
