import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../service/login.service.dart';
import '../service/event.service.dart';
import 'controller/eventos_controller.dart';
import 'evento.page.dart';

class BookmarkPage extends GetView<EventosController> {
  final int userId;

  BookmarkPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.loadUserBookmarks(userId);
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Favoritos"),
      ),
      body: controller.obx(
            (state) => ListView.builder(
              itemCount: controller.bookmarks.length,
          itemBuilder: (context, index) {
            final bookmarks = controller.bookmarks[index];
            return Card(
              child: ListTile(
                leading: Image.network(bookmarks.imgEvent, width: 100, height: 100, fit: BoxFit.cover),
                title: Text(bookmarks.eventName),
                subtitle: Text(bookmarks.centerName),
                onTap: () {
                  Get.to(EventoPage(event: bookmarks));
                },
              ),
            );
          },
        ),
        onLoading: Center(child: CircularProgressIndicator()),
        onError: (error) => Center(child: Text('Failed to load bookmarks: $error')),
      ),
    );
  }
}
