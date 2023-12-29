import 'package:flutter/material.dart';
import 'package:oriotv/src/models/content.dart';

class CarouselCard extends StatelessWidget {
  final PageController pageController;
  final List<Media> carouselContent;
  final Function(Media) onTap;

  const CarouselCard({
    Key? key,
    required this.pageController,
    required this.carouselContent,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        controller: pageController,
        itemCount: carouselContent.length,
        itemBuilder: (context, index) {
          final media = carouselContent[index % carouselContent.length];
          return _buildCarouselItem(media);
        },
      ),
    );
  }

  Widget _buildCarouselItem(Media media) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          onTap(media);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    image: DecorationImage(
                      image: NetworkImage(media.backdropUrl ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      media.title ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Color del texto
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
