import 'package:fimage/models/Topic.dart';
import 'package:fimage/providers/global_provider.dart';
import 'package:fimage/screens/Detail.dart';
import 'package:fimage/screens/Search.dart';
import 'package:fimage/widgets/PhotoCard.dart';
import 'package:fimage/widgets/SearchInput.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static String name = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool init = true;
  void handleSubmit(value) async {
    var response =
        await context.read<GlobalProvider>().getPhotos(search: value);
    if (response.isNotEmpty) {
      Navigator.of(context).pushNamed('/search', arguments: {'search': value});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        'Data tidak ditemukan',
      )));
    }
  }

  @override
  void didChangeDependencies() {
    if (init) {
      Provider.of<GlobalProvider>(context, listen: false).getTopics();
      setState(() {
        init = false;
      });
    }
    Provider.of<GlobalProvider>(context).getFavoritesPhotos();
    super.didChangeDependencies();
  }

  void handleClickTopic(Topic topic) {
    Provider.of<GlobalProvider>(context, listen: false)
        .getPhotosByTopic(topicId: topic.id);
    Navigator.pushNamed(context, Search.name,
        arguments: {'topicId': topic.id, 'search': ''});
  }

  void handleClickDetail(String photoId) {
    Navigator.pushNamed(context, DetailPhoto.name, arguments: photoId);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    var topics = context.watch<GlobalProvider>().topics;
    var favorites = context.watch<GlobalProvider>().favorites;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
          height: height,
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('What are you looking for?',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 40,
                        color: Colors.black54)),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SearchInput(
                    placeholder: 'Search...',
                    onSubmit: handleSubmit,
                  ),
                ),
                SizedBox(
                  height: favorites.isNotEmpty ? 200 : 300,
                  child: GridView.count(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    scrollDirection: Axis.horizontal,
                    crossAxisCount: favorites.isNotEmpty ? 1 : 2,
                    children: topics
                        .map((e) => InkWell(
                              onTap: () => handleClickTopic(e),
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              NetworkImage(e.cover_photo.small),
                                          fit: BoxFit.cover)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(e.title,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                    color: Colors.black,
                                                    blurRadius: 10)
                                              ])),
                                    ],
                                  )),
                            ))
                        .toList(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: favorites.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 10,
                    ),
                    itemBuilder: (context, index) {
                      return PhotoCard(
                          data: favorites[index],
                          onTap: () {
                            handleClickDetail(favorites[index].id);
                          });
                    },
                  ),
                )
              ],
            ),
          ),
        )));
  }
}
