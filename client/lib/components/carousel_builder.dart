import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:client/constants.dart';

class WorthySliders extends StatelessWidget {
  const WorthySliders({super.key, required this.snapshot});

  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CarouselSlider.builder(
        itemCount: 10,
        options: CarouselOptions(
          height: 300,
          aspectRatio: 16 / 9,
          viewportFraction: 0.15,
          // enlargeCenterPage: true,
          enableInfiniteScroll: false,
          autoPlay: true,
        ), 
        itemBuilder: (context,itemIndex, pageViewIndex){
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 300,
              width: 200,
              child: Image.network(
                filterQuality: FilterQuality.high,
                '${Constants.imagePath}${snapshot.data[itemIndex].posterPath}',
                fit: BoxFit.cover,
              ),
            ),
          );
        }, 
      )
    );
  }
}