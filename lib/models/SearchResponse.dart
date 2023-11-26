import 'package:fimage/models/Pagination.dart';
import 'package:fimage/models/Photo.dart';

class SearchResponse extends Pagination {
  List<Photo> results;

  SearchResponse(
      {required this.results, required super.total, required super.totalPage});
}
