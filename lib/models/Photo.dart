import 'package:fimage/models/Urls.dart';

class Photo {
  String id;
  String slug;
  String created_at;
  int width;
  int height;
  String color;
  String description;
  String alt_description;
  Urls urls;
  int likes;
  List<String> tags;
  int views;
  int downloads;
  String uploadBy;

  Photo({
    required this.id,
    required this.slug,
    required this.created_at,
    required this.width,
    required this.height,
    required this.color,
    required this.description,
    required this.alt_description,
    required this.urls,
    required this.likes,
    required this.tags,
    required this.views,
    required this.downloads,
    required this.uploadBy,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'slug': slug,
        'created_at': created_at,
        'width': width,
        'height': height,
        'color': color,
        'description': description,
        'alt_description': alt_description,
        'urls': {
          'raw': urls.raw,
          'full': urls.full,
          'regular': urls.regular,
          'small': urls.small,
          'thumb': urls.thumb,
          'small_s3': urls.small_s3,
        },
        'likes': likes,
        'tags': tags,
        'views': views,
        'downloads': downloads,
        'uploadBy': uploadBy,
      };
}
