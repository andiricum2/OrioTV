import 'package:flutter/material.dart';
import 'package:oriotv/src/models/content.dart';

class ContentCard extends StatelessWidget {
  final Media media;
  final Function(Media) onTap;

  const ContentCard({Key? key, required this.media, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: 130.0,
              height: 300.0,
              child: GestureDetector(
                onTap: () => onTap(media),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(media.posterUrl ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
