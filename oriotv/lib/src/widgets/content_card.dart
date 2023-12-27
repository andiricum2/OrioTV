import 'package:flutter/material.dart';
import 'package:oriotv/src/models/content.dart';

class ContentCard extends StatelessWidget {
  final Media media;

  ContentCard({required this.media});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: 150.0,
              height: 150.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      8.0), // Ajusta el valor según tus preferencias
                  image: DecorationImage(
                    image: NetworkImage(media.posterUrl ?? ''),
                    fit: BoxFit.cover,
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
