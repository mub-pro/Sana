import 'package:flutter/material.dart';
import 'package:original_sana/database/cloud_firestore/data_provider.dart';
import 'package:original_sana/database/moor/favorites.dart';
import 'package:original_sana/screens/series_screen.dart';
import 'package:original_sana/sizes_information/device_type.dart';
import 'package:original_sana/sizes_information/widget_info.dart';
import 'package:original_sana/widgets/one_card_in_row.dart';
import 'package:provider/provider.dart';

import '../custom_icon_icons.dart';
import 'movie_screen.dart';
import 'podcast_screen.dart';
import 'story_screen.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var myDatabase = Provider.of<MyDatabase>(context);
    var dataProvider = Provider.of<DataProvider>(context);
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: WidgetInfo(
        builder: (context, deviceInfo) {
          return Column(
            children: [
              // Header
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: deviceInfo.height / 3,
                    color: Color(0xFFFF414C),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      CustomIcon.heart,
                      size: deviceInfo.deviceType == DeviceType.Mobile
                          ? 150.0
                          : 250.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: StreamBuilder<List<Favorite>>(
                  stream: myDatabase.allFavorites.asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data.length > 0)
                      return GridView.count(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount:
                              deviceInfo.deviceType == DeviceType.Mobile
                                  ? 3
                                  : 4,
                          childAspectRatio: 130.0 / 180.0,
                          children: List.generate(
                            snapshot.data.length,
                            (index) {
                              Favorite favorite = snapshot.data[index];
                              return OneCardInRow(
                                id: favorite.id,
                                name: favorite.name,
                                image: favorite.image,
                                category: favorite.category,
                                onTap: () {
                                  if (favorite.category == 'story') {
                                    dataProvider.getStoryById(favorite.id).then(
                                        (value) => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    StoryScreen(
                                                        story: value))));
                                  }
                                  if (favorite.category == 'podcast') {
                                    dataProvider
                                        .getPodcastById(favorite.id)
                                        .then((value) => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PodcastScreen(
                                                        podcast: value))));
                                  }
                                  if (favorite.category == 'movie') {
                                    dataProvider.getMovieById(favorite.id).then(
                                        (value) => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MovieScreen(
                                                        movie: value))));
                                  }
                                  if (favorite.category == 'series') {
                                    dataProvider
                                        .getSeriesById(favorite.id)
                                        .then((value) => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SeriesScreen(
                                                        series: value))));
                                  }
                                },
                              );
                            },
                          ));
                    return Container(
                      padding: EdgeInsets.only(top: 30.0),
                      child: Text(
                        'لا توجد إعجابات !',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            fontFamily: 'Dubai M',
                            color: Colors.black38,
                            fontSize: deviceInfo.deviceType == DeviceType.Mobile
                                ? 30.0
                                : 60.0),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
