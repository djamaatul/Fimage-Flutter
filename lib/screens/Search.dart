import 'package:fimage/providers/global_provider.dart';
import 'package:fimage/screens/Detail.dart';
import 'package:fimage/widgets/PhotoCard.dart';
import 'package:fimage/widgets/SearchInput.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  static String name = '/search';

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String search = '';
  String topicId = '';
  bool loading = false;
  bool isEnd = false;
  int page = 1;

  @override
  void didChangeDependencies() {
    Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    setState(() {
      search = arguments['search'] ?? '';
      topicId = arguments['topicId'] ?? '';
    });
    super.didChangeDependencies();
  }

  Future<int> getPhotos({String? value, int? page, bool add = false}) {
    if (topicId.isNotEmpty) {
      Provider.of<GlobalProvider>(context, listen: false)
          .getPhotosByTopic(topicId: topicId, search: value ?? '', add: true)
          .then((value) {});
      setState(() {
        loading = false;
      });
      return Future.value(1);
    }
    Provider.of<GlobalProvider>(context, listen: false)
        .getPhotos(search: value ?? '', page: page, add: add)
        .then((value) {
      setState(() {
        isEnd = value.isEmpty;
        loading = false;
      });
    });
    return Future.value(1);
  }

  void handleSubmit(String value) {
    getPhotos(value: value);
    setState(() {
      search = value;
    });
  }

  void handleClickDetail(String photoId) {
    Navigator.pushNamed(context, DetailPhoto.name, arguments: photoId);
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      final scroll = _scrollController.offset;
      final max = _scrollController.position.maxScrollExtent;
      if (scroll >= max - 300 && topicId.isEmpty && !isEnd) {
        setState(() {
          page++;
          if (!loading) {
            loading = true;
            getPhotos(page: page, value: search, add: true);
          }
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = context.watch<GlobalProvider>().photos;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.only(right: 5),
          child: SearchInput(
              value: search, placeholder: 'Search..', onSubmit: handleSubmit),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.teal),
        titleSpacing: 0,
      ),
      body: SafeArea(
          child: ListView.separated(
              controller: _scrollController,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    PhotoCard(
                      key: Key(data[index].id),
                      data: data[index],
                      onTap: () => handleClickDetail(data[index].id),
                    ),
                    loading && index == data.length - 1 && !isEnd
                        ? Container(
                            padding: const EdgeInsets.all(10),
                            child: const CircularProgressIndicator(),
                          )
                        : Container(),
                    index == data.length - 1 && isEnd
                        ? Container(
                            padding: const EdgeInsets.all(10),
                            child: const Text('Berakhir'),
                          )
                        : Container()
                  ],
                );
              },
              separatorBuilder: (context, index) => const Divider(
                    height: 10,
                  ),
              itemCount: data.length)),
    );
  }
}
