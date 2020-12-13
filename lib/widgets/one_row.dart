import 'package:flutter/material.dart';
import 'package:original_sana/screens/movie_screen.dart';
import 'package:original_sana/screens/podcast_screen.dart';
import 'package:original_sana/screens/series_screen.dart';
import 'package:original_sana/screens/story_screen.dart';
import 'package:original_sana/sizes_information/device_type.dart';
import 'package:original_sana/sizes_information/widget_info.dart';
import 'package:original_sana/widgets/name_of_section.dart';

import 'one_card_in_row.dart';

class OneRow extends StatelessWidget {
  final String name;
  final Future future;
  final String category;
  OneRow({this.name, this.future, this.category});
  @override
  Widget build(BuildContext context) {
    return WidgetInfo(
      builder: (context, deviceInfo) => Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: deviceInfo.width * 0.03),
            child: NameOfSection(name: name),
          ),
          SizedBox(height: deviceInfo.height * 0.03),
          Container(
            height: deviceInfo.deviceType == DeviceType.Mobile
                ? deviceInfo.height * 0.23
                : 290.0,
            margin: EdgeInsets.only(bottom: 30.0),
            padding: deviceInfo.deviceType == DeviceType.Mobile
                ? const EdgeInsets.only(right: 10.0, left: 10.0)
                : const EdgeInsets.only(right: 10.0, left: 10.0),
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
                              if (this.name == 'الأفلام') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MovieScreen(
                                            movie: snapshot.data[index])));
                              }
                              if (this.name == 'الرسوم المتحركة') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SeriesScreen(
                                            series: snapshot.data[index])));
                              }
                              if (this.name == 'القصص') {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StoryScreen(
                                            story: snapshot.data[index])));
                              }
                              if (this.name == 'الصوتيات') {
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
      ),
    );
  }
}
