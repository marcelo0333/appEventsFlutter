import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../service/login.service.dart';
import 'circle.dart';
import 'evento.page.dart';
import 'filter_item.page.dart';
import 'square.dart';
import 'controller/eventos_controller.dart';

class EventosPage extends GetView<EventosController> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.findEvents();
      final userId = await LoginService.getUserId();
      if (userId != null) {
        controller.loadUserBookmarks(userId);
      } else {
        print("error, id null");
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: _buildSearchField(),
        actions: _buildActions(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCategoryList(),
            _buildFavoriteSection(),
            _buildRecentEventsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        itemCount: controller.category.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.to(FilterItemPage(categoryType: controller.category[index]));
            },
            child: Circle(child: controller.category[index]),
          );
        },
      ),
    );
  }

  Widget _buildEventList() {
    return Obx(() {
      if (controller.isLoadingEvents.value) {
        return Center(child: CircularProgressIndicator());
      }
      return SizedBox(
        height: 300,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.events.length,
          itemBuilder: (context, index) {
            final event = controller.events[index];
            return Square(
              img: event.imgEvent,
              child: event.eventName,
              title: event.eventName,
              subtitle: event.centerName,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventoPage(event: event)),
                );
              },
            );
          },
        ),
      );
    });
  }

Widget _buildFavoriteSection() {

    return Obx(() {
      if (controller.isLoadingBookmarks.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text('Meus favoritos', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.bookmarks.length,
              itemBuilder: (context, index) {
                final bookmarks = controller.bookmarks[index];
                return Square(
                  img: bookmarks.imgEvent,
                  child: bookmarks.eventName,
                  title: bookmarks.eventName,
                  subtitle: bookmarks.centerName,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EventoPage(event: bookmarks)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildRecentEventsSection() {
    return Obx(() {
      if (controller.isLoadingEvents.value) {
        return Center(child: CircularProgressIndicator());
      }
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text('Eventos Recentes', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.events.length,
              itemBuilder: (context, index) {
                final event = controller.events[index];
                return Square(
                  img: event.imgEvent,
                  child: event.eventName,
                  title: event.eventName,
                  subtitle: event.centerName,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EventoPage(event: event)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSearchField() {
    return TextField(
      controller: controller.searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black),
      ),
      style: TextStyle(color: Colors.black, fontSize: 16.0),
    );
  }

  List<Widget> _buildActions() {
    if (controller.isSearching.value) {
      return <Widget>[
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            controller.stopSearch();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: Icon(Icons.search),
        onPressed: controller.startSearch,
      ),
    ];
  }
}
