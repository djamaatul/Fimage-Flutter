import 'dart:convert';

import 'package:fimage/config/api.dart';
import 'package:fimage/models/Pagination.dart';
import 'package:fimage/models/Photo.dart';
import 'package:fimage/models/SearchResponse.dart';
import 'package:fimage/models/Topic.dart';
import 'package:fimage/models/Urls.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalProvider with ChangeNotifier {
  late Photo detailPhoto;
  List<Photo> _photos = [];
  List<Topic> _topics = [];
  List<Photo> _favorites = [];
  Pagination _pagination = Pagination(total: 0, totalPage: 0);

  List<Photo> get photos => _photos;
  List<Topic> get topics => _topics;
  Pagination get pagination => _pagination;
  List<Photo> get favorites => _favorites;

  Future<List<Photo>> getPhotos(
      {String search = '', int? page = 1, bool add = false}) async {
    final raw = await httpRequestGet(
        '/search/photos', {'query': search, 'page': page.toString()});
    final SearchResponse response = SearchResponse(
        results: List.from(raw['results'])
            .map((result) => Photo(
                id: result['id'].toString(),
                slug: result['slug'].toString(),
                created_at: result['created_at'].toString(),
                width: result['width'],
                height: result['height'],
                color: result['color'].toString(),
                description: result['description'].toString(),
                alt_description: result['alt_description'].toString(),
                urls: Urls(
                  raw: result['urls']['raw'],
                  full: result['urls']['full'],
                  regular: result['urls']['regular'],
                  small: result['urls']['small'],
                  thumb: result['urls']['thumb'],
                  small_s3: result['urls']['small_s3'],
                ),
                likes: result['likes'],
                views: 0,
                downloads: 0,
                uploadBy: result['user']['name'],
                tags: List.from(result['tags'])
                    .map((e) => e['title'].toString())
                    .toList()))
            .toList(),
        total: raw['total'],
        totalPage: raw['total_pages']);

    final List<Photo> results = response.results;
    if (add) {
      _photos.addAll(results);
    } else {
      _photos = results;
    }
    _pagination =
        Pagination(total: response.total, totalPage: response.totalPage);

    notifyListeners();
    return results;
  }

  Future<List<Photo>> getPhotosByTopic(
      {required String topicId,
      String search = '',
      int page = 1,
      bool add = false}) async {
    _photos = [];
    final raw = await httpRequestGet(
        '/topics/$topicId/photos', {'query': search, 'page': page.toString()});
    final List<Photo> response = List.from(raw)
        .map((result) => Photo(
            id: result['id'].toString(),
            slug: result['slug'].toString(),
            created_at: result['created_at'].toString(),
            width: result['width'],
            height: result['height'],
            color: result['color'].toString(),
            description: result['description'].toString(),
            alt_description: result['alt_description'].toString(),
            urls: Urls(
              raw: result['urls']['raw'],
              full: result['urls']['full'],
              regular: result['urls']['regular'],
              small: result['urls']['small'],
              thumb: result['urls']['thumb'],
              small_s3: result['urls']['small_s3'],
            ),
            likes: result['likes'],
            views: 0,
            downloads: 0,
            uploadBy: result['user']['name'],
            tags: []))
        .toList();

    final List<Photo> results = response;
    _photos = results;
    _pagination = Pagination(total: 0, totalPage: 0);

    notifyListeners();
    return results;
  }

  Future<List<Topic>> getTopics({String search = ''}) async {
    final raw = await httpRequestGet('/topics', {});
    final List<Topic> response = List.from(raw)
        .map((e) => Topic(
              id: e['id'],
              title: e['title'],
              description: e['description'],
              total_photos: e['total_photos'],
              color: int.parse(
                  'FF${e['cover_photo']['color'].toString().replaceFirst('#', '')}',
                  radix: 16),
              cover_photo: Urls(
                  raw: e['cover_photo']['urls']['raw'],
                  full: e['cover_photo']['urls']['full'],
                  regular: e['cover_photo']['urls']['regular'],
                  small: e['cover_photo']['urls']['small'],
                  thumb: e['cover_photo']['urls']['thumb'],
                  small_s3: e['cover_photo']['urls']['small_s3']),
            ))
        .toList();
    _topics = response;

    notifyListeners();
    return response;
  }

  Future<Photo> getDetailPhoto(String photoId) async {
    final Map<String, dynamic> raw =
        await httpRequestGet('/photos/$photoId', {});
    return Photo(
        id: raw['id'].toString(),
        slug: raw['slug'].toString(),
        created_at: raw['created_at'].toString(),
        width: raw['width'],
        height: raw['height'],
        color: raw['color'].toString(),
        description: raw['description'].toString(),
        alt_description: raw['alt_description'].toString(),
        urls: Urls(
          raw: raw['urls']['raw'],
          full: raw['urls']['full'],
          regular: raw['urls']['regular'],
          small: raw['urls']['small'],
          thumb: raw['urls']['thumb'],
          small_s3: raw['urls']['small_s3'],
        ),
        likes: raw['likes'],
        views: raw['views'],
        downloads: raw['downloads'],
        uploadBy: raw['user']['name'],
        tags:
            List.from(raw['tags']).map((e) => e['title'].toString()).toList());
  }

  Future<List<Photo>> getFavoritesPhotos(
      {String search = '', int? page = 1, bool add = false}) async {
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

    final prefs = await _prefs;

    final String? favorites = prefs.getString('favorites');

    List<Photo> results = [];
    if (favorites != null) {
      final Map<String, dynamic> favoritesParsed = jsonDecode(favorites);
      results = favoritesParsed.entries
          .map((item) => Photo(
              id: item.value['id'].toString(),
              slug: item.value['slug'].toString(),
              created_at: item.value['created_at'].toString(),
              width: item.value['width'],
              height: item.value['height'],
              color: item.value['color'].toString(),
              description: item.value['description'].toString(),
              alt_description: item.value['alt_description'].toString(),
              urls: Urls(
                raw: item.value['urls']['raw'],
                full: item.value['urls']['full'],
                regular: item.value['urls']['regular'],
                small: item.value['urls']['small'],
                thumb: item.value['urls']['thumb'],
                small_s3: item.value['urls']['small_s3'],
              ),
              likes: item.value['likes'],
              views: item.value['views'],
              downloads: item.value['downloads'],
              uploadBy: item.value['uploadBy'],
              tags: List.from(item.value['tags'])
                  .map((e) => e.toString())
                  .toList()))
          .toList();
    }

    _favorites = results;

    notifyListeners();
    return results;
  }
}
