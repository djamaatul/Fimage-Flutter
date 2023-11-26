import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  String placeholder = '';
  Function onSubmit = () => null;
  Color color = Colors.teal;

  SearchInput(
      {super.key,
      required this.placeholder,
      required this.onSubmit,
      String? value});

  @override
  Widget build(BuildContext context) {
    return TextField(
      autocorrect: false,
      cursorColor: Colors.teal,
      style: const TextStyle(color: Colors.teal),
      onSubmitted: (String value) {
        onSubmit(value);
      },
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(4))),
          filled: true,
          fillColor: Colors.teal.withOpacity(.25),
          hintText: placeholder,
          hintStyle: const TextStyle(color: Colors.teal),
          suffixIcon: const Icon(
            Icons.search,
            color: Colors.teal,
          )),
    );
  }
}
