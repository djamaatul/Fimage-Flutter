import 'package:fimage/models/Photo.dart';
import 'package:flutter/material.dart';

class PhotoCard extends StatelessWidget {
  Photo data;
  Function() onTap;
  PhotoCard({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Image.network(data.urls.thumb, fit: BoxFit.cover),
              ),
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.alt_description,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      data.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w300),
                    ),
                  )),
                  Wrap(
                    direction: Axis.horizontal,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 5,
                    children: [
                      const Icon(
                        Icons.favorite,
                        size: 15,
                      ),
                      Text(data.likes.toString())
                    ],
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
