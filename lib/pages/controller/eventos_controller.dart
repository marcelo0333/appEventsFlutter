import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../model/event.model.dart';
import '../../repository/i_events_repository.dart';
import '../../service/login.service.dart';

class EventosController extends GetxController with StateMixin<List<Event>> {
  final IEventsRepository _eventsRepository;

  EventosController(this._eventsRepository);

  final searchController = TextEditingController();
  var isSearching = false.obs;
  var category = ['Culturais', 'Técnico-Científicos', 'Profissionais', 'Oficiais', 'Sociais'].obs;
  var isBookmarked = false.obs;
  var events = <Event>[].obs;
  var bookmarks = <Event>[].obs;
  var eventsFilter = <Event>[].obs;

  var isLoadingEvents = false.obs;
  var isLoadingBookmarks = false.obs;
  @override
  void onInit() {
    super.onInit();
    findEvents();
  }

  Future<void> findEvents() async {
    change(null, status: RxStatus.loading());
    try {
      events.clear();
      final dados = await _eventsRepository.findAllEvents();
      events.addAll(dados);
      change(dados, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    } finally{
      isLoadingEvents.value = false;
    }
  }


  Future<void> addBookmark(int eventId) async {
    try {
      final userId = await LoginService.getUserId();
      if (userId != null) {
        await _eventsRepository.addBookmark(userId, eventId);
        isBookmarked.value = true;
      } else {
        throw Exception('Usuário não logado.');
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
  Future<void> removeBookmark(int userId, int eventId) async {
    try {
      await _eventsRepository.removeBookmark(userId, eventId);
      isBookmarked.value = false;
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  Future<void> checkBookmark(int userId, int eventId) async {
    try {
      final bool hasBookmarked = await _eventsRepository.checkBookmark(userId, eventId);
      isBookmarked.value = hasBookmarked;
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
  Future<void> loadEventsByCategory(String categoryType) async {
    change(null, status: RxStatus.loading());
    try {
      eventsFilter.clear();
      final dados = await _eventsRepository.getEventsByType(categoryType);
      eventsFilter.addAll(dados);
      change(dados, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }
  Future<void> loadUserBookmarks(int userId) async {
    isLoadingBookmarks.value = true;
    try {
      final fetchedBookmarks = await _eventsRepository.getUserBookmarks(userId);
      bookmarks.assignAll(fetchedBookmarks);
      change(bookmarks, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));

      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingBookmarks.value = false;
    }
  } startSearch() {
    isSearching.value = true;
  }

  void stopSearch() {
    isSearching.value = false;
    searchController.clear();
  }
}