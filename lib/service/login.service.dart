import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.model.dart';

class LoginService {
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:9090/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data != null && data.containsKey('user') && data['user']['userId'] != null) {
        final userId = data['user']['userId'];
        final firstName = data['user']['firstName'];
        final lastName = data['user']['lastName'];
        final email = data['user']['email'];
        final role = data['user']['role'];
        final token = data['tokens']['accessToken'];
        await _saveUserId(userId);
        final user = User(firstName: firstName, lastName: lastName, email: email, role: role);
        await _saveUser(user);
        await _saveToken(token);
        return true;
      } else {
        print('Login bem-sucedido, mas o campo userId não está presente ou é nulo.');
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<String?> _getToken() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
  static Future<void> _saveToken (String token) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }
  static Future<void> _saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }
  static Future<User?> getUserFromToken() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }
  static Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString('user', userJson);
  }
  static Future<void> editUser(User user) async {
    final token = await _getToken();
    if(token != null){
      print(token);
    }
    final response = await http.put(
      Uri.parse('http://10.0.2.2:9090/api/auth/edit'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email,
      }),
    );

    if (response.statusCode == 200) {
      print('200');
      await _saveUser(user);
    } else {
      throw Exception('Failed to edit user');
    }
  }
  static Future<void> storageClear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

