import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:original_sana/models/models.dart';
import 'package:original_sana/sizes_information/device_type.dart';
import 'package:original_sana/sizes_information/widget_info.dart';
import 'package:original_sana/widgets/circular_like.dart';
import 'package:original_sana/widgets/custom_back_button.dart';
import 'package:original_sana/widgets/custom_icon_button.dart';
import 'package:original_sana/widgets/name_of_row.dart';
import 'package:share/share.dart';

import '../custom_icon_icons.dart';

class HeaderPage extends SliverPersistentHeaderDelegate {
  final double maxE;
  final double minE;
  final Series series;
  final Function onTap;
  HeaderPage({this.maxE, this.minE, this.series, this.onTap});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return WidgetInfo(
      builder: (context, deviceInfo) {
        return Stack(
          alignment: Alignment.center,
          children: [
            //image
            Container(
              color: Colors.grey.shade900,
              child: Opacity(
                opacity: .2,
                child: CachedNetworkImage(
                  imageUrl: series.image,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: imageProvider,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
            //shadow in the bottom
            // Container(color: Colors.deepPurple.withOpacity(.6)),
            // Container(
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       colors: [Colors.transparent, Colors.black45],
            //       stops: [0.5, 1.0],
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //       tileMode: TileMode.repeated,
            //     ),
            //   ),
            // ),
            //Back Button
            CustomBackButton(),
            //Texts
            Positioned(
              right: deviceInfo.width * .06,
              top: deviceInfo.localHeight * .1,
              child: Container(
                // color: Colors.black.withOpacity(.7),
                width: deviceInfo.width * .8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.rtl,
                  children: [
                    //Name
                    Text(series.name,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: deviceInfo.width * .1,
                            color: Colors.white,
                            fontFamily: 'Dubai B')),
                    //Date
                    Text(series.date,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: deviceInfo.width * .05,
                            color: Colors.white,
                            fontFamily: 'Dubai R')),
                    //Description
                    Text(series.description,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: deviceInfo.width * .05,
                          color: Colors.white,
                          fontFamily: 'Dubai R',
                        ))
                  ],
                ),
              ),
            ),
            //Icons
            Positioned(
              bottom: deviceInfo.width * .04,
              child: Row(
                children: [
                  //Share
                  CustomIconButton(
                    onTap: () {
                      Share.share('شارك ${series.name} مع أصدقائك');
                    },
                    icon: CustomIcon.share,
                    size: deviceInfo.localHeight * .08,
                    color: Colors.white,
                  ),
                  SizedBox(width: deviceInfo.localWidth * 0.06),
                  //Play
                  CustomIconButton(
                    onTap: onTap,
                    icon: Icons.play_circle_filled_rounded,
                    size: deviceInfo.localHeight * .24,
                    color: Colors.white,
                  ),
                  SizedBox(width: deviceInfo.localWidth * 0.06),
                  //Like
                  CircularLike(
                    id: series.id,
                    name: series.name,
                    image: series.image,
                    category: 'series',
                    size: deviceInfo.localHeight * .08,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  double titleOpacity(double shrinkOffset) {
    // simple formula: fade out text as soon as shrinkOffset > 0
    return 1.0 - max(0.0, shrinkOffset) / maxExtent;
    // more complex formula: starts fading out text when shrinkOffset > minExtent
    //return 1.0 - max(0.0, (shrinkOffset - minExtent)) / (maxExtent - minExtent);
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => this.maxE;

  @override
  // TODO: implement minExtent
  double get minExtent => this.minE;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;
}

class SeriesScreen extends StatefulWidget {
  final Series series;
  SeriesScreen({this.series});

  @override
  _SeriesScreenState createState() => _SeriesScreenState();
}

class _SeriesScreenState extends State<SeriesScreen>
    with SingleTickerProviderStateMixin {
  int _selectedSeason = 0;
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
        vsync: this,
        length: widget.series.content.length,
        initialIndex: widget.series.content.length - 1);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WidgetInfo(
        builder: (context, deviceInfo) {
          return CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: HeaderPage(
                    minE: deviceInfo.height / 2.5,
                    maxE: deviceInfo.height / 1.8,
                    series: widget.series,
                    onTap: () {
                      // FlutterYoutube.playYoutubeVideoByUrl(
                      //   fullScreen: true,
                      //   autoPlay: true,
                      //   apiKey: 'AIzaSyBLZp-aggOeFQm4tJeWdUTfznGGb9nWPhQ',
                      //   videoUrl: widget.series.content[_selectedSeason].url[0],
                      // );
                    }),
              ),
              SliverToBoxAdapter(
                  child: SizedBox(height: deviceInfo.height * .05)),
              //Tab Bar
              SliverToBoxAdapter(
                  child: Container(
                alignment: Alignment.center,
                height: deviceInfo.deviceType == DeviceType.Mobile
                    ? deviceInfo.width * .06
                    : deviceInfo.width * .05,
                padding:
                    EdgeInsets.symmetric(horizontal: deviceInfo.width * .04),
                child: WidgetInfo(
                  builder: (context, tabBarInfo) {
                    return TabBar(
                      controller: _tabController,
                      onTap: (int newIndex) {
                        setState(() {
                          _selectedSeason =
                              widget.series.content.length - 1 - newIndex;
                        });
                      },
                      physics: BouncingScrollPhysics(),
                      isScrollable: true,
                      unselectedLabelColor: Colors.blueGrey,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                          color: Color(0xFF5300B4),
                          borderRadius: BorderRadius.circular(
                            40.0,
                          )),
                      tabs:
                          List.generate(widget.series.content.length, (index) {
                        return Tab(
                          child: Text(widget.series.content[index].name,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontFamily: 'Dubai M',
                                fontSize: tabBarInfo.localHeight * .5,
                              )),
                        );
                      }).reversed.toList(),
                    );
                  },
                ),
              )),
              //Title
              SliverToBoxAdapter(
                child: Container(
                  alignment: Alignment.centerRight,
                  height: deviceInfo.height * .06,
                  margin: EdgeInsets.only(
                    right: deviceInfo.width * .1,
                    top: deviceInfo.height * .03,
                    bottom: deviceInfo.height * .01,
                  ),
                  child: NameOfRow(name: 'الحلقات'),
                ),
              ),
              //Episodes
              SliverToBoxAdapter(
                child: Container(
                  height: (deviceInfo.height * .168) *
                      widget.series.content[_selectedSeason].episodes.length,
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children:
                        List.generate(widget.series.content.length, (index) {
                      return ListView.builder(
                        padding: EdgeInsets.all(0),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.series.content[index].episodes.length,
                        itemBuilder: (context, i) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: deviceInfo.height * .04),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16.0),
                                onTap: () {
                                  // FlutterYoutube.playYoutubeVideoByUrl(
                                  //   autoPlay: true,
                                  //   fullScreen: true,
                                  //   appBarVisible: true,
                                  //   apiKey:
                                  //       'AIzaSyBLZp-aggOeFQm4tJeWdUTfznGGb9nWPhQ',
                                  //   videoUrl:
                                  //       widget.series.content[index].url[i],
                                  // );
                                },
                                child: Container(
                                  height: deviceInfo.height * .13,
                                  width: deviceInfo.width * .8,
                                  decoration: BoxDecoration(
                                    color: Color(
                                      int.parse(widget.series.color),
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      deviceInfo.deviceType == DeviceType.Mobile
                                          ? deviceInfo.width * .08
                                          : deviceInfo.width * .06,
                                    ),
                                  ),
                                  child: WidgetInfo(
                                    builder: (context, boxInfo) {
                                      return Stack(
                                        children: [
                                          //Image
                                          Positioned(
                                            right: 0,
                                            child: CachedNetworkImage(
                                              imageUrl: widget.series.image,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                height: boxInfo.localHeight,
                                                width: boxInfo.localWidth * .34,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight: Radius.circular(
                                                      deviceInfo.deviceType ==
                                                              DeviceType.Mobile
                                                          ? deviceInfo.width *
                                                              .08
                                                          : deviceInfo.width *
                                                              .06,
                                                    ),
                                                    bottomRight:
                                                        Radius.circular(
                                                      deviceInfo.deviceType ==
                                                              DeviceType.Mobile
                                                          ? deviceInfo.width *
                                                              .08
                                                          : deviceInfo.width *
                                                              .06,
                                                    ),
                                                  ),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: imageProvider),
                                                ),
                                              ),
                                              placeholder: (context, url) => Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            ),
                                          ),
                                          //Text's
                                          Positioned(
                                            right: boxInfo.localWidth * .38,
                                            top: boxInfo.localHeight * .1,
                                            child: Container(
                                              width: boxInfo.localWidth * .55,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  //Episode_name
                                                  FittedBox(
                                                    child: Text(
                                                      widget
                                                          .series
                                                          .content[index]
                                                          .episodes[i],
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: boxInfo
                                                                  .localHeight *
                                                              .23,
                                                          fontFamily:
                                                              'Dubai B'),
                                                    ),
                                                  ),
                                                  //Season_name
                                                  FittedBox(
                                                    child: Text(
                                                      [
                                                        'الحلقة الأولى',
                                                        'الحلقة الثانية',
                                                        'الحلقة الثالثة',
                                                        'الحلقة الرابعة',
                                                        'الحلقة الخامسة'
                                                      ][i],
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: boxInfo
                                                                  .localHeight *
                                                              .15,
                                                          fontFamily:
                                                              'Dubai M'),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).reversed.toList(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
