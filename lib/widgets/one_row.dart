import 'package:flutter/material.dart';
import 'package:original_sana/screens/movie_screen.dart';
import 'package:original_sana/screens/podcast_screen.dart';
import 'package:original_sana/screens/series_screen.dart';
import 'package:original_sana/screens/story_screen.dart';
import 'package:original_sana/sizes_information/device_type.dart';
import 'package:original_sana/sizes_information/widget_info.dart';
import 'package:original_sana/widgets/name_of_row.dart';

import 'one_card_in_row.dart';

class OneRow extends StatelessWidget {
  final String name;
  final Future future;
  final String category;
  OneRow({this.name, this.future, this.category});
  @override
  Widget build(BuildContext context) {
    return WidgetInfo(
      builder: (context, deviceInfo) {
        return Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              height: deviceInfo.height * .06,
              margin: EdgeInsets.only(right: deviceInfo.width * .03),
              child: NameOfRow(name: name),
            ),
            SizedBox(height: deviceInfo.height * .02),
            Container(
              height: deviceInfo.deviceType == DeviceType.Mobile
                  ? deviceInfo.height * .27
                  : deviceInfo.height * .29,
              margin: EdgeInsets.only(bottom: deviceInfo.height * .04),
              padding: EdgeInsets.only(
                  right: deviceInfo.width * 0.02,
                  left: deviceInfo.width * 0.02),
              child: FutureBuilder(
                future: future,
                builder: (context, snapshot) => snapshot.hasData
                    ? ListView.builder(
                        reverse: true,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              left: deviceInfo.deviceType == DeviceType.Mobile
                                  ? 0
                                  : deviceInfo.width * 0.01,
                            ),
                            child: OneCardInRow(
                              id: snapshot.data[index].id,
                              name: snapshot.data[index].name,
                              image: snapshot.data[index].image,
                              category: category,
                              onTap: () {
                                if (this.category == 'movie') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MovieScreen(
                                              movie: snapshot.data[index])));
                                }
                                if (this.category == 'series') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SeriesScreen(
                                              series: snapshot.data[index])));
                                }
                                if (this.category == 'story') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => StoryScreen(
                                              story: snapshot.data[index])));
                                }
                                if (this.category == 'podcast') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PodcastScreen(
                                              podcast: snapshot.data[index])));
                                }
                              },
                            ),
                          );
                        },
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        );
      },
    );
  }
}
