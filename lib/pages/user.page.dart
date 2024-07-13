
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:untitled/service/login.service.dart';

import '../model/user.model.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  User? userModel;
  bool isAdmin = false;
  bool isModalOpen = false;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    userModel = await LoginService.getUserFromToken();
    if (userModel != null) {
      setState(() {
        isAdmin = userModel!.role == 'admin';
        firstNameController.text = userModel!.firstName;
        lastNameController.text = userModel!.lastName;
        emailController.text = userModel!.email;
      });
    }
  }

  void _openEditModal() {
    setState(() {
      isModalOpen = true;
    });
  }

  void _closeModal() {
    setState(() {
      isModalOpen = false;
    });
  }

  Future<void> _editUser() async {
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty) {
      _showErrorToast('Por favor, preencha todos os campos corretamente.');
      return;
    }

    final editedUser = User(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      role: userModel?.role ?? 'user',
    );

    try {
      await LoginService.editUser(editedUser);
      _closeModal();
      _showSuccessToast('Informações atualizadas com sucesso!');
      setState(() {
        userModel = editedUser;
      });
    } catch (error) {
      _showErrorToast('Erro ao atualizar. Tente novamente mais tarde.');
    }
  }

  void _showErrorToast(String message) {
    Get.snackbar('Erro', message, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
  }

  void _showSuccessToast(String message) {
    Get.snackbar('Sucesso', message, snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
  }

  void _logout() {
    LoginService.storageClear();
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuário'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: userModel == null
          ? Center(child: CircularProgressIndicator())
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nome: ${userModel!.firstName}'),
            Text('Sobrenome: ${userModel!.lastName}'),
            Text('Email: ${userModel!.email}'),
              ElevatedButton(
                onPressed: _openEditModal,
                child: Text('Editar Usuário'),
              ),
          ],
        ),
      ),

      bottomSheet: isModalOpen
          ? Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Sobrenome'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _editUser,
                child: Text('Salvar'),
              ),
              TextButton(
                onPressed: _closeModal,
                child: Text('Fechar'),
              ),
            ],
          ),
        ),
      )
          : SizedBox.shrink(),
    );
  }
}
