import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {
  static User? currentUser;

  static Future<User> login(String username, String password) async {
  final response = await http.post(
    Uri.parse('https://openspeak.nicolairar.it/api/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'username': username, 'password': password}),
  );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    print("✅ Login success: $json"); // 👈 debug
    final user = User.fromJson(json);
    currentUser = user;
    return user;
  } else {
    print("❌ Login failed: ${response.statusCode} ${response.body}"); // 👈 debug
    throw Exception('Login failed');
  }
}


  static User? get user => currentUser;
}
