import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/event.model.dart';
import '../../service/login.service.dart';
import 'controller/eventos_controller.dart';

class EventoPage extends GetView<EventosController> {
  final Event event;

  EventoPage({required this.event});

  @override
  Widget build(BuildContext context) {
    _checkBookmarkStatus(); // Mova a chamada para aqui

    final LatLng _eventLocation = LatLng(-29.712, -53.7169); // Example coordinates for UFSM

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.network(event.imgEvent, fit: BoxFit.cover),
            ),
            buttonArrow(context),
            scroll(),
          ],
        ),
      ),
    );
  }

  void _checkBookmarkStatus() async {
    final userId = await LoginService.getUserId();
    if (userId != null) {
      await controller.checkBookmark(userId, event.eventsId);
    }
  }

  Widget buttonArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget scroll() {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      maxChildSize: 1.0,
      minChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 5,
                        width: 35,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 2,
                      ),
                      child: Text(
                        event.eventName,
                        style: Theme.of(context).textTheme.titleLarge,
                        overflow: TextOverflow.ellipsis, // This will ensure the text does not overflow
                      ),
                    ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          final userId = await LoginService.getUserId();
                          if (userId != null) {
                            if (controller.isBookmarked.value) {
                              await controller.removeBookmark(userId, event.eventsId);
                            } else {
                              await controller.addBookmark( event.eventsId);
                            }
                          } else {
                            print('User not logged in');
                          }
                        },
                        child: Obx(() {
                          return Column(
                            children: [
                              Text(
                                event.totalBookmarks.toString(),
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: controller.isBookmarked.value ? Colors.red : Colors.white,
                                child: Icon(CupertinoIcons.heart, color: controller.isBookmarked.value ? Colors.white : Colors.red),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5,),
                Text(
                  "Data: ${event.dateInitial} - ${event.dateFinal}",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.black),
                ),
                const SizedBox(height: 15,),
                Row(
                  children: [
                    const Icon(
                      Icons.location_pin,
                      size: 30,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 2,),
                    Text(
                      "Local: ${event.centerName}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.black54),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(
                    height: 4,
                  ),
                ),
                Text(
                  "Descrição",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10,),
                Text(
                  event.description,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.black87),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(
                    height: 4,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
