import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../model/register.model.dart';
import '../service/register.service.dart';
import 'login.page.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  File? _image;

  final ImagePicker _picker = ImagePicker();

  void _showErrorToast(String message) {
    Get.snackbar(
      'Erro',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _showSuccessToast(String message) {
    Get.snackbar(
      'Sucesso',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          top: 150,
          left: 40,
          right: 40,
        ),
        color: const Color(0xff424242),
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 89,
              height: 82,
              child: Image.asset('assets/logo.png', fit: BoxFit.fitHeight),
            ),
            const SizedBox(height: 20),
            const Text(
              "SmartEventos",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontFamily: "Inter",
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "E-mail",
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: firstNameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: "Nome",
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: lastNameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: "Sobrenome",
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _image == null
                ? TextButton(
              onPressed: _pickImage,
              child: const Text("Tirar Foto"),
            )
                : Image.file(
              _image!,
              height: 150,
            ),
            const SizedBox(height: 40),
            Container(
              height: 60,
              width: 50,
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: SizedBox.expand(
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Colors.transparent),
                    shadowColor:
                    MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Text("Cadastrar",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  onPressed: () async {
                    if (_image == null) {
                      _showErrorToast('Por favor, tire uma foto.');
                      return;
                    }
                    final UserDTO user = UserDTO(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      imgUser: _image!.path,
                    );
                    bool success = await RegisterService.register(user);
                    if (success) {
                      _showSuccessToast('Registro bem-sucedido!');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    } else {
                      _showErrorToast('Falha no registro. Tente novamente.');
                    }
                  },
                ),
              ),
            ),
            Container(
              height: 80,
              alignment: Alignment.center,
              child: TextButton(
                child: const Text("Já tem login? Entre aqui",
                    style: TextStyle(fontSize: 15)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
