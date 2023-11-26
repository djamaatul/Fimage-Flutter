import 'package:fimage/providers/global_provider.dart';
import 'package:fimage/screens/Detail.dart';
import 'package:fimage/screens/Homepage.dart';
import 'package:fimage/screens/Search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => GlobalProvider())],
      child: const Root()));
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomePage.name,
      routes: {
        HomePage.name: (context) => const HomePage(),
        Search.name: (context) => Search(),
        DetailPhoto.name: (context) => DetailPhoto()
      },
    );
  }
}
