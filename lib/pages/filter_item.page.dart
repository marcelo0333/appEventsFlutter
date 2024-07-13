import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/event.model.dart';
import '../../service/login.service.dart';
import '../service/event.service.dart';
import 'controller/eventos_controller.dart';
import 'evento.page.dart';
import 'eventos.page.dart';

class FilterItemPage extends StatelessWidget {
  final String categoryType;
  final EventosController controller = Get.find<EventosController>();

  FilterItemPage({required this.categoryType});

  @override
  Widget build(BuildContext context) {
    // Carrega os eventos da categoria ao inicializar a página
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      controller.loadEventsByCategory(categoryType);  });
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryType),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.to(EventosPage());
          },
        ),
      ),
      body: controller.obx(
            (state) => ListView.builder(
          itemCount: state?.length ?? 0,
          itemBuilder: (context, index) {
            final eventsFilter = state![index];
            return Card(
              child: ListTile(
                leading: Image.network(eventsFilter.imgEvent, width: 100, height: 100, fit: BoxFit.cover),
                title: Text(eventsFilter.eventName),
                subtitle: Text(eventsFilter.centerName),
                onTap: () {
                  Get.to(EventoPage(event: eventsFilter));
                },
              ),
            );
          },
        ),
        onLoading: Center(child: CircularProgressIndicator()),
        onError: (error) => Center(child: Text('Failed to load events: $error')),
      ),
    );
  }
}
