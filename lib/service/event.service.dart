import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/event.model.dart';
import '../repository/i_events_repository.dart';

class EventService implements IEventsRepository {
  @override
  Future<List<Event>> findAllEvents() async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:9090/api/events/date'));

    if (response.statusCode == 200) {
      final dynamic jsonResponse = jsonDecode(response.body);
      print('API Response: $jsonResponse');

      if (jsonResponse is Map<String, dynamic> &&
          jsonResponse.containsKey('content')) {
        final List<dynamic> eventsList = jsonResponse['content'];
        return eventsList.map<Event>((resp) => Event.fromJson(resp)).toList();
      } else {
        throw Exception('Failed to parse events');
      }
    } else {
      throw Exception('Failed to load events: ${response.statusCode}');
    }
  }

  @override
  Future<void> addBookmark(int userId, int eventId) async {
    print("entrou");
    final response = await http.post(
      Uri.parse('http://10.0.2.2:9090/api/bookmarks/save'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },

      body: jsonEncode(<String, int>{
        'userId': userId,
        'eventId': eventId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao adicionar evento aos favoritos');
    }
  }

  @override
  Future<bool> checkBookmark(int userId, int eventId) async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:9090/api/bookmarks/$userId/$eventId')
    );

    if (response.statusCode == 200) {
      final bool hasBookmarked = jsonDecode(response.body);
      return hasBookmarked;
    } else {
      throw Exception('Failed to check bookmark status');
    }
  }

  @override
  Future<void> removeBookmark(int userId, int eventId) async {
    final response = await http.delete(
        Uri.parse('http://10.0.2.2:9090/api/bookmarks/delete/$userId/$eventId')
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to remove bookmark');
    }
  }

  @override
  Future<List<Event>> getEventsByType(String typeEvent) async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2:9090/api/events/type?type=$typeEvent'));
    if (response.statusCode == 200) {
      final dynamic jsonResponse = jsonDecode(response.body);
      print('API Response: $jsonResponse');

      if (jsonResponse is List) {
        return jsonResponse.map<Event>((item) => Event.fromJson(item)).toList();
      } else {
        throw Exception('Failed to parse events');
      }
    } else {
      throw Exception('Failed to load events');
    }
  }

  // Future<List<Event>> getEventsByType(String typeEvent) async {
  //   final response = await http.get(
  //       Uri.parse('http://10.0.2.2:9090/api/events/$typeEvent'));
  //   if (response.statusCode == 200) {
  //     List<dynamic> body = jsonDecode(response.body);
  //     return body.map((dynamic item) => Event.fromJson(item)).toList();
  //   } else {
  //     throw Exception('Failed to load events');
  //   }
  // }

    Future<List<Event>> getUserBookmarks(int userId) async {
      final response = await http.get(
          Uri.parse('http://10.0.2.2:9090/api/bookmarks/$userId'));
      if (response.statusCode == 200) {
        final dynamic jsonResponse = jsonDecode(response.body);
        print('API Response: $jsonResponse');

        if (jsonResponse is List) {
          return jsonResponse.map<Event>((item) => Event.fromJson(item))
              .toList();
        } else {
          throw Exception('Failed to parse events');
        }
      } else {
        throw Exception('Failed to load events');
      }
    }
}
