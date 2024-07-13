

import 'package:get/get.dart';
import 'package:untitled/pages/controller/eventos_controller.dart';
import 'package:untitled/repository/i_events_repository.dart';

import '../../service/event.service.dart';

class EventosBindings implements Bindings{
  @override
  void dependencies() {
    Get.put<IEventsRepository>(EventService());
    Get.put(EventosController(Get.find()));
  }

}