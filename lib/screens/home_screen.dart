import 'dart:math';

import 'package:flutter/material.dart';
import 'package:original_sana/database/cloud_firestore/data_provider.dart';
import 'package:original_sana/sizes_information/device_type.dart';
import 'package:original_sana/sizes_information/widget_info.dart';
import 'package:original_sana/widgets/one_row.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'movie_screen.dart';
import 'podcast_screen.dart';
import 'series_screen.dart';
import 'story_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    final dataProvider = Provider.of<DataProvider>(context);
    var random = Random().nextInt(4);
    return SingleChildScrollView(
      child: Column(
        children: [
          //Header
          Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            child: WidgetInfo(
              builder: (context, deviceInfo) {
                return FutureBuilder(
                    future: Future.wait([
                      dataProvider.fetchMovie(),
                      dataProvider.fetchSeries(),
                      dataProvider.fetchStory(),
                      dataProvider.fetchPodcast()
                    ]),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? Stack(
                              textDirection: TextDirection.rtl,
                              children: [
                                PageView.builder(
                                  reverse: true,
                                  controller: pageController,
                                  itemCount:
                                      snapshot.data[random].take(3).length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    List list =
                                        snapshot.data[random].reversed.toList();
                                    return InkWell(
                                      onTap: () {
                                        if (random == 0)
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MovieScreen(
                                                          movie: snapshot.data[
                                                              random][snapshot
                                                                  .data[random]
                                                                  .length -
                                                              1 -
                                                              index])));
                                        if (random == 1)
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SeriesScreen(
                                                          series: snapshot.data[
                                                              random][snapshot
                                                                  .data[random]
                                                                  .length -
                                                              1 -
                                                              index])));
                                        if (random == 2)
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StoryScreen(
                                                          story: snapshot.data[
                                                              random][snapshot
                                                                  .data[random]
                                                                  .length -
                                                              1 -
                                                              index])));
                                        if (random == 3)
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PodcastScreen(
                                                          podcast: snapshot
                                                                  .data[
                                                              random][snapshot
                                                                  .data[random]
                                                                  .length -
                                                              1 -
                                                              index])));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  list[index].image),
                                              fit: BoxFit.cover),
                                        ),
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          color: Colors.black26,
                                          margin: const EdgeInsets.only(
                                              right: 40.0),
                                          child: Text(
                                            list[index].name,
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                                fontSize:
                                                    deviceInfo.deviceType ==
                                                            DeviceType.Mobile
                                                        ? 30.0
                                                        : 50.0,
                                                fontFamily: 'Dubai M',
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                //Dots
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  padding: EdgeInsets.only(bottom: 20.0),
                                  child: SmoothPageIndicator(
                                    controller: pageController,
                                    textDirection: TextDirection.rtl,
                                    count: snapshot.data[random].take(3).length,
                                    effect: WormEffect(
                                        spacing: deviceInfo.deviceType ==
                                                DeviceType.Mobile
                                            ? 10.0
                                            : 20.0,
                                        activeDotColor: Colors.deepPurple,
                                        dotColor: Colors.white,
                                        dotHeight: deviceInfo.deviceType ==
                                                DeviceType.Mobile
                                            ? 7.0
                                            : 15.0,
                                        dotWidth: deviceInfo.deviceType ==
                                                DeviceType.Mobile
                                            ? 7.0
                                            : 15.0),
                                  ),
                                )
                              ],
                            )
                          : Center(child: CircularProgressIndicator());
                    });
              },
            ),
          ),
          SizedBox(height: 40.0),
          Column(
            children: [
              OneRow(
                future: dataProvider.fetchMovie(),
                name: 'الأفلام',
                category: 'movie',
              ),
              OneRow(
                future: dataProvider.fetchSeries(),
                name: 'الرسوم المتحركة',
                category: 'series',
              ),
              OneRow(
                future: dataProvider.fetchStory(),
                name: 'القصص',
                category: 'story',
              ),
              OneRow(
                future: dataProvider.fetchPodcast(),
                name: 'الصوتيات',
                category: 'podcast',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
