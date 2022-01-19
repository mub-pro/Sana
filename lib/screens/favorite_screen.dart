import 'package:flutter/material.dart';
import 'package:original_sana/database/cloud_firestore/controller.dart';
import 'package:original_sana/database/moor/favorites.dart';
import 'package:original_sana/screens/series_screen.dart';
import 'package:original_sana/sizes_information/device_type.dart';
import 'package:original_sana/sizes_information/widget_info.dart';
import 'package:original_sana/widgets/helper_widgets.dart';
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
    Controller data = Controller();
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
              // content
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FutureBuilder(
                  future: myDatabase.allFavorites,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Favorite>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        return error('Nothing Happens');
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        return loading();
                      case ConnectionState.done:
                        if (snapshot.hasError) return error(snapshot.error);
                        if (!snapshot.hasData) return error('No Data');
                        if (snapshot.data.length < 1)
                          return Container(
                            padding: EdgeInsets.only(top: 30.0),
                            child: Text(
                              'لا توجد إعجابات !',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                  fontFamily: 'Dubai M',
                                  color: Colors.grey,
                                  fontSize:
                                      deviceInfo.deviceType == DeviceType.Mobile
                                          ? 30.0
                                          : 60.0),
                            ),
                          );
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
                                    switch (favorite.category) {
                                      case 'story':
                                        data.getStoryById(favorite.id).then(
                                            (value) => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        StoryScreen(
                                                            story: value))));
                                        break;
                                      case 'podcast':
                                        data.getPodcastById(favorite.id).then(
                                            (value) => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PodcastScreen(
                                                            podcast: value))));
                                        break;
                                      case 'movie':
                                        data.getMovieById(favorite.id).then(
                                            (value) => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MovieScreen(
                                                            movie: value))));
                                        break;
                                      case 'series':
                                        data.getSeriesById(favorite.id).then(
                                            (value) => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SeriesScreen(
                                                            series: value))));
                                        break;
                                    }
                                  },
                                );
                              },
                            ));
                    }
                    return Container();
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
