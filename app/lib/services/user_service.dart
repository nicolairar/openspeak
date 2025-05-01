import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserService {
  static Future<List<User>> fetchUsers() async {
    final response = await http.get(
      Uri.parse('https://openspeak.nicolairar.it/api/users'),
      headers: {
        'role': 'admin', // solo per debug, poi token!
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
