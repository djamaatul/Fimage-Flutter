import 'package:fimage/models/Urls.dart';

class Topic {
  String id;
  String title;
  String description;
  int color;
  int total_photos;
  Urls cover_photo;

  Topic({
    required this.id,
    required this.title,
    required this.description,
    required this.color,
    required this.total_photos,
    required this.cover_photo,
  });
}
