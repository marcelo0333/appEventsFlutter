import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/pages/bookmark.page.dart';
import 'package:untitled/pages/user.page.dart';
import 'controller/tab_controlle.dart';
import 'eventos.page.dart';
import 'filter_item.page.dart';
import '../service/login.service.dart';

class MainTabs extends StatelessWidget {
  final TabsController tabsController = Get.put(TabsController());

  Future<int?> getUserId() async {
    return await LoginService.getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      future: getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          final userId = snapshot.data ?? 0; // Assuming 0 is the guest user ID
          return Obx(() {
            return Scaffold(
              body: IndexedStack(
                index: tabsController.selectedIndex.value,
                children: [
                  EventosPage(),
                  BookmarkPage(userId: userId),
                  UserPage(),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bookmark),
                    label: 'Bookmarks',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'User',
                  ),
                ],
                currentIndex: tabsController.selectedIndex.value,
                onTap: tabsController.onItemTapped,
              ),
            );
          });
        }
      },
    );
  }
}
