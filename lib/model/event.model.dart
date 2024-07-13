class Event {
  int eventsId;
  String eventName;
  String imgEvent;
  String centerName;
  String contact;
  String link;
  String description;
  String typeEvent;
  String dateInitial;
  String dateFinal;
  double averageRating;
  int totalBookmarks;

  Event({
    required this.eventsId,
    required this.eventName,
    required this.imgEvent,
    required this.centerName,
    required this.contact,
    required this.link,
    required this.description,
    required this.typeEvent,
    required this.dateInitial,
    required this.dateFinal,
    required this.averageRating,
    required this.totalBookmarks,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventsId: json['eventsId'] ?? 0,
      eventName: json['eventName'] ?? '',
      imgEvent: json['imgEvent'] ?? '',
      centerName: json['centerName'] ?? '',
      contact: json['contact'] ?? '',
      link: json['link'] ?? '',
      description: json['description'] ?? '',
      typeEvent: json['typeEvent'] ?? '',
      dateInitial: json['dateInitial'] ?? '',
      dateFinal: json['dateFinal'] ?? '',
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      totalBookmarks: json['totalBookmarks'] ?? 0,
    );
  }
}
