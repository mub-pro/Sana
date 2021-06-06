import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:original_sana/database/cloud_firestore/data_provider.dart';
import 'package:original_sana/models/models.dart';
import 'package:original_sana/screens/series_screen.dart';
import 'package:original_sana/screens/story_screen.dart';
import 'package:original_sana/sizes_information/device_type.dart';
import 'package:original_sana/sizes_information/widget_info.dart';
import 'package:original_sana/widgets/name_of_row.dart';
import 'package:original_sana/widgets/one_card_in_row.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'movie_screen.dart';
import 'podcast_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dataProvider = Provider.of<DataProvider>(context, listen: false);
    var random = Random().nextInt(4);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Container(
            height: MediaQuery.of(context).size.height / 3,
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
                                  controller: _pageController,
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
                                      child: CachedNetworkImage(
                                        imageUrl: list[index].image,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            color: Colors.black.withOpacity(.3),
                                            margin: EdgeInsets.only(
                                                right:
                                                    deviceInfo.localWidth * 0.1,
                                                left:
                                                    deviceInfo.localWidth / 4),
                                            child: Text(
                                              list[index].name,
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                  fontSize:
                                                      deviceInfo.localWidth *
                                                          .07,
                                                  fontFamily: 'Dubai M',
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                      ),
                                    );
                                  },
                                ),
                                //Dots
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  padding: EdgeInsets.only(
                                      bottom: deviceInfo.localHeight * 0.1),
                                  child: SmoothPageIndicator(
                                    controller: _pageController,
                                    textDirection: TextDirection.rtl,
                                    count: snapshot.data[random].take(3).length,
                                    effect: WormEffect(
                                      spacing: deviceInfo.localWidth * .03,
                                      activeDotColor: Color(0xFF2A0651),
                                      dotColor: Colors.white,
                                      dotHeight: deviceInfo.localWidth * 0.015,
                                      dotWidth: deviceInfo.localWidth * 0.015,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Center(child: CircularProgressIndicator());
                    });
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          Column(
            children: [
              WidgetInfo(
                builder: (context, deviceInfo) {
                  return Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        height: deviceInfo.height * .06,
                        margin: EdgeInsets.only(right: deviceInfo.width * .03),
                        child: NameOfRow(name: 'الأفــــــلام'),
                      ),
                      SizedBox(height: deviceInfo.height * .02),
                      Container(
                        height: deviceInfo.deviceType == DeviceType.Mobile
                            ? deviceInfo.width * .48
                            : deviceInfo.height * .29,
                        margin:
                            EdgeInsets.only(bottom: deviceInfo.height * .04),
                        padding: EdgeInsets.only(
                            right: deviceInfo.width * 0.02,
                            left: deviceInfo.width * 0.02),
                        child: FutureBuilder(
                            future: dataProvider.fetchMovie(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return ListView.builder(
                                  reverse: true,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: dataProvider.movieLength,
                                  itemBuilder: (context, index) {
                                    Movie movie = dataProvider.movies[index];
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: deviceInfo.deviceType ==
                                                DeviceType.Mobile
                                            ? 0
                                            : deviceInfo.width * 0.01,
                                      ),
                                      child: OneCardInRow(
                                        id: movie.id,
                                        name: movie.name,
                                        image: movie.image,
                                        category: 'movie',
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MovieScreen(
                                                          movie: movie)));
                                        },
                                      ),
                                    );
                                  },
                                );
                              }
                            }),
                      ),
                    ],
                  );
                },
              ),
              WidgetInfo(
                builder: (context, deviceInfo) {
                  return Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        height: deviceInfo.height * .06,
                        margin: EdgeInsets.only(right: deviceInfo.width * .03),
                        child: NameOfRow(name: 'المسلسلات'),
                      ),
                      SizedBox(height: deviceInfo.height * .02),
                      Container(
                        height: deviceInfo.deviceType == DeviceType.Mobile
                            ? deviceInfo.width * .48
                            : deviceInfo.height * .29,
                        margin:
                            EdgeInsets.only(bottom: deviceInfo.height * .04),
                        padding: EdgeInsets.only(
                            right: deviceInfo.width * 0.02,
                            left: deviceInfo.width * 0.02),
                        child: FutureBuilder(
                            future: dataProvider.fetchSeries(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return ListView.builder(
                                  reverse: true,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: dataProvider.seriesLength,
                                  itemBuilder: (context, index) {
                                    Series series = dataProvider.series[index];
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: deviceInfo.deviceType ==
                                                DeviceType.Mobile
                                            ? 0
                                            : deviceInfo.width * 0.01,
                                      ),
                                      child: OneCardInRow(
                                        id: series.id,
                                        name: series.name,
                                        image: series.image,
                                        category: 'series',
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SeriesScreen(
                                                          series: series)));
                                        },
                                      ),
                                    );
                                  },
                                );
                              }
                            }),
                      ),
                    ],
                  );
                },
              ),
              WidgetInfo(
                builder: (context, deviceInfo) {
                  return Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        height: deviceInfo.height * .06,
                        margin: EdgeInsets.only(right: deviceInfo.width * .03),
                        child: NameOfRow(name: 'القصص'),
                      ),
                      SizedBox(height: deviceInfo.height * .02),
                      Container(
                        height: deviceInfo.deviceType == DeviceType.Mobile
                            ? deviceInfo.width * .48
                            : deviceInfo.height * .29,
                        margin:
                            EdgeInsets.only(bottom: deviceInfo.height * .04),
                        padding: EdgeInsets.only(
                            right: deviceInfo.width * 0.02,
                            left: deviceInfo.width * 0.02),
                        child: FutureBuilder(
                            future: dataProvider.fetchStory(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return ListView.builder(
                                  reverse: true,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: dataProvider.storyLength,
                                  itemBuilder: (context, index) {
                                    Story story = dataProvider.stories[index];
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: deviceInfo.deviceType ==
                                                DeviceType.Mobile
                                            ? 0
                                            : deviceInfo.width * 0.01,
                                      ),
                                      child: OneCardInRow(
                                        id: story.id,
                                        name: story.name,
                                        image: story.image,
                                        category: 'story',
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StoryScreen(
                                                          story: story)));
                                        },
                                      ),
                                    );
                                  },
                                );
                              }
                            }),
                      ),
                    ],
                  );
                },
              ),
              WidgetInfo(
                builder: (context, deviceInfo) {
                  return Column(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        height: deviceInfo.height * .06,
                        margin: EdgeInsets.only(right: deviceInfo.width * .03),
                        child: NameOfRow(name: 'الصوتيات'),
                      ),
                      SizedBox(height: deviceInfo.height * .02),
                      Container(
                        height: deviceInfo.deviceType == DeviceType.Mobile
                            ? deviceInfo.width * .48
                            : deviceInfo.height * .29,
                        margin:
                            EdgeInsets.only(bottom: deviceInfo.height * .04),
                        padding: EdgeInsets.only(
                            right: deviceInfo.width * 0.02,
                            left: deviceInfo.width * 0.02),
                        child: FutureBuilder(
                            future: dataProvider.fetchPodcast(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return ListView.builder(
                                  reverse: true,
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: dataProvider.podcastLength,
                                  itemBuilder: (context, index) {
                                    Podcast podcast =
                                        dataProvider.podcast[index];
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: deviceInfo.deviceType ==
                                                DeviceType.Mobile
                                            ? 0
                                            : deviceInfo.width * 0.01,
                                      ),
                                      child: OneCardInRow(
                                        id: podcast.id,
                                        name: podcast.name,
                                        image: podcast.image,
                                        category: 'podcast',
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PodcastScreen(
                                                          podcast: podcast)));
                                        },
                                      ),
                                    );
                                  },
                                );
                              }
                            }),
                      ),
                    ],
                  );
                },
              ),
              // OneRow(
              //   future: dataProvider.fetchSeries(),
              //   name: 'الرسوم المتحركة',
              //   category: 'series',
              // ),
              // OneRow(
              //   future: dataProvider.fetchStory(),
              //   name: 'القصــص',
              //   category: 'story',
              // ),
              // OneRow(
              //   future: dataProvider.fetchPodcast(),
              //   name: 'الصوتيات',
              //   category: 'podcast',
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
