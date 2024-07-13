import 'dart:convert';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Import necessário para definir o content type
import '../model/register.model.dart';

class RegisterService {
  static Future<bool> register(UserDTO user) async {
    var uri = Uri.parse('http://10.0.2.2:9090/api/auth/register');

    var request = http.MultipartRequest('POST', uri)
      ..fields['data'] = jsonEncode(user.toJson());

    if (user.imgUser.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath(
        'imgUser',
        user.imgUser,
        filename: basename(user.imgUser),
        contentType: MediaType('image', 'jpeg'), // Definindo o content type
      ));
    }

    var response = await request.send();

    return response.statusCode == 200;
  }
}
