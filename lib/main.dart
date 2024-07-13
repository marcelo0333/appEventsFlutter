import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:untitled/pages/binding/eventos_binding.dart';
import 'package:untitled/pages/cadastro.page.dart';
import 'package:untitled/pages/controller/eventos_controller.dart';
import 'package:untitled/pages/evento.page.dart';
import 'package:untitled/pages/eventos.page.dart';
import 'package:untitled/pages/tabs.page.dart';
import 'package:untitled/service/event.service.dart';

import 'pages/login.page.dart';

void main() {
  Get.put(EventosController(EventService()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/cadastro', page: () => CadastroPage()),
        GetPage(name: '/eventos', page: () => MainTabs(), binding: EventosBindings()),
        // GetPage(name: '/evento', page: () => EventoPage()),
      ],
      home: MainTabs(),
      initialRoute: '/login',
    );
  }
}
