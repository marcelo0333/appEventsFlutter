import 'dart:ffi';

import '../model/event.model.dart';

abstract class IEventsRepository{
  Future<List<Event>> findAllEvents();

  Future<void> addBookmark(int userId, int eventId);
  Future<bool> checkBookmark(int userId, int eventId);
  Future<void> removeBookmark(int userId, int eventId);
  Future<List<Event>>  getEventsByType(String typeEvent);
  Future<List<Event>> getUserBookmarks(int userId);
}