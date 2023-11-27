import 'dart:convert';

import 'package:fimage/models/Photo.dart';
import 'package:fimage/providers/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailPhoto extends StatefulWidget {
  static String name = '/detail-photo';

  @override
  State<DetailPhoto> createState() => _DetailPhotoState();
}

class _DetailPhotoState extends State<DetailPhoto> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Photo? data;
  bool isFavorite = false;

  Future<void> getFavorites(String photoId) async {
    final photo =
        await Provider.of<GlobalProvider>(context).getDetailPhoto(photoId);
    final SharedPreferences prefs = await _prefs;
    String? favorites = prefs.getString('favorites');
    setState(() {
      data = photo;
      if (favorites != null) {
        Map<String, dynamic> favoritesParsed = jsonDecode(favorites);
        isFavorite = favoritesParsed[data!.id] != null;
      }
    });
  }

  @override
  void didChangeDependencies() async {
    final photoId = ModalRoute.of(context)!.settings.arguments as String;
    getFavorites(photoId);
    super.didChangeDependencies();
  }

  Future<void> handleFavorite() async {
    final SharedPreferences prefs = await _prefs;
    bool favorite = false;

    String? favorites = prefs.getString('favorites');
    if (favorites != null) {
      Map<String, dynamic> favoritesParsed = jsonDecode(favorites);

      if (isFavorite) {
        favoritesParsed.remove(data!.id);
      } else {
        favorite = true;
        favoritesParsed[data!.id] = data;
      }

      await prefs.setString('favorites', jsonEncode(favoritesParsed));
    } else {
      await prefs.setString(
          'favorites', jsonEncode({data!.id: data!.toJson()}));
    }
    setState(() {
      Provider.of<GlobalProvider>(context, listen: false).getFavoritesPhotos();
      isFavorite = favorite;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double imageHeight = MediaQuery.of(context).size.height * .4;
    DateTime? date = DateTime.tryParse(data?.created_at ?? '');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        actions: data != null
            ? [
                IconButton(
                  icon: const Icon(Icons.favorite),
                  color: isFavorite ? Colors.pink : Colors.white,
                  onPressed: handleFavorite,
                )
              ]
            : [],
      ),
      body: data == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    data!.urls.regular,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: imageHeight,
                  ),
                  SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 5,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Icon(Icons.calendar_month_outlined,
                                  size: 15),
                              Text(
                                date != null
                                    ? 'Dibuat tanggal ${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute}'
                                    : '',
                                style: const TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                          Wrap(
                            spacing: 5,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Icon(Icons.favorite_outline, size: 15),
                              Text(
                                '${data!.likes.toString()} Disukai',
                                style: const TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                          Wrap(
                            spacing: 5,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Icon(Icons.remove_red_eye_outlined,
                                  size: 15),
                              Text(
                                '${data!.views.toString()} Dilihat',
                                style: const TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                          Wrap(
                            spacing: 5,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Icon(Icons.download, size: 15),
                              Text(
                                '${data!.downloads.toString()} Diunduh',
                                style: const TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              data!.description == 'null'
                                  ? data!.alt_description
                                  : data!.description,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                          ),
                          Wrap(
                            spacing: 5,
                            runSpacing: 5,
                            children: data!.tags
                                .map((e) => Container(
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color: Colors.grey),
                                      padding: const EdgeInsets.all(2),
                                      child: Text(
                                        e,
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                    ))
                                .toList(),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )),
    );
  }
}
