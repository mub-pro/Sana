import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:original_sana/models/models.dart';
import 'package:original_sana/sizes_information/widget_info.dart';
import 'package:original_sana/widgets/circular_like.dart';
import 'package:original_sana/widgets/custom_back_button.dart';
import 'package:original_sana/widgets/custom_icon_button.dart';
import 'package:share/share.dart';

import '../custom_icon_icons.dart';

class MovieScreen extends StatelessWidget {
  final Movie movie;
  MovieScreen({this.movie});
  static const String id = 'movie_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WidgetInfo(
        builder: (context, deviceInfo) {
          return Stack(
            alignment: Alignment.center,
            children: [
              //Image
              CachedNetworkImage(
                imageUrl: movie.image,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
              ),
              //Back Button
              CustomBackButton(),
              //Name
              Positioned(
                top: deviceInfo.height * 0.2,
                child: Text(
                  movie.name,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: deviceInfo.width * .1,
                      color: Colors.white,
                      fontFamily: 'Dubai M'),
                ),
              ),
              //Icons
              Positioned(
                bottom: deviceInfo.height * .25,
                child: Row(
                  children: [
                    //Share
                    CustomIconButton(
                      onTap: () {
                        print('SHARE Movie');
                        Share.share('شارك ${movie.name} مع أصدقائك');
                      },
                      icon: CustomIcon.share,
                      size: deviceInfo.width * .11,
                      color: Colors.white,
                    ),
                    SizedBox(width: deviceInfo.width * .06),
                    //Play
                    CustomIconButton(
                      onTap: () {
                        FlutterYoutube.playYoutubeVideoByUrl(
                          fullScreen: true,
                          autoPlay: true,
                          apiKey: 'AIzaSyBLZp-aggOeFQm4tJeWdUTfznGGb9nWPhQ',
                          videoUrl: movie.url,
                        );
                      },
                      icon: Icons.play_circle_filled_rounded,
                      size: deviceInfo.width * .3,
                      color: Colors.white,
                    ),
                    SizedBox(width: deviceInfo.width * .06),
                    //Like
                    CircularLike(
                      id: movie.id,
                      name: movie.name,
                      image: movie.image,
                      category: 'movie',
                      size: deviceInfo.width * .11,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
