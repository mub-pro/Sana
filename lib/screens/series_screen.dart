import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:original_sana/models/models.dart';
import 'package:original_sana/sizes_information/device_type.dart';
import 'package:original_sana/sizes_information/widget_info.dart';
import 'package:original_sana/widgets/circular_like.dart';
import 'package:original_sana/widgets/custom_back_button.dart';
import 'package:original_sana/widgets/custom_icon_button.dart';
import 'package:original_sana/widgets/name_of_row.dart';
import 'package:share/share.dart';

import '../custom_icon_icons.dart';

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
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: HeaderPage(
                    minE: MediaQuery.of(context).size.height / 2,
                    maxE: MediaQuery.of(context).size.height / 1.5,
                    series: widget.series,
                    onTap: () {
                      FlutterYoutube.playYoutubeVideoByUrl(
                        fullScreen: true,
                        autoPlay: true,
                        apiKey: 'AIzaSyBLZp-aggOeFQm4tJeWdUTfznGGb9nWPhQ',
                        videoUrl: widget.series.content[_selectedSeason].url[0],
                      );
                    }),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 30.0)),
              //Tab Bar
              SliverToBoxAdapter(
                  child: Container(
                alignment: Alignment.center,
                height:
                    deviceInfo.deviceType == DeviceType.Mobile ? 30.0 : 60.0,
                padding: EdgeInsets.only(right: 20.0, left: 20),
                child: TabBar(
                  onTap: (int newIndex) {
                    setState(() {
                      _selectedSeason =
                          widget.series.content.length - 1 - newIndex;
                    });
                  },
                  controller: _tabController,
                  physics: BouncingScrollPhysics(),
                  isScrollable: true,
                  unselectedLabelColor: Colors.black54,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                      color: Color(0xFF5300B4),
                      borderRadius: BorderRadius.circular(
                        40,
                      )),
                  tabs: List.generate(widget.series.content.length, (index) {
                    return Container(
                      height: 150.0,
                      padding: EdgeInsets.only(
                          left: deviceInfo.deviceType == DeviceType.Mobile
                              ? 10.0
                              : 20.0,
                          right: deviceInfo.deviceType == DeviceType.Mobile
                              ? 10.0
                              : 20.0),
                      child: Tab(
                        child: Text(widget.series.content[index].name,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: 'Dubai M',
                              fontSize:
                                  deviceInfo.deviceType == DeviceType.Mobile
                                      ? 15.0
                                      : 30.0,
                            )),
                      ),
                    );
                  }).reversed.toList(),
                ),
              )),
              //Title
              SliverToBoxAdapter(
                child: Container(
                    alignment: Alignment.centerRight,
                    padding:
                        EdgeInsets.only(right: 40.0, top: 20.0, bottom: 10.0),
                    child: NameOfRow(name: 'الحلقات')),
              ),
              //Episodes
              SliverToBoxAdapter(
                child: Container(
                  height: (deviceInfo.deviceType == DeviceType.Mobile
                          ? 130.0
                          : 180.0) *
                      widget.series.content[_selectedSeason].episodes.length,
                  child: TabBarView(
                    controller: _tabController,
                    children:
                        List.generate(widget.series.content.length, (index) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(top: 10.0),
                        itemCount: widget.series.content[index].episodes.length,
                        itemBuilder: (context, i) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 30.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16.0),
                                onTap: () {
                                  FlutterYoutube.playYoutubeVideoByUrl(
                                    autoPlay: true,
                                    fullScreen: true,
                                    apiKey:
                                        'AIzaSyBLZp-aggOeFQm4tJeWdUTfznGGb9nWPhQ',
                                    videoUrl:
                                        widget.series.content[index].url[i],
                                  );
                                },
                                child: Stack(
                                  children: [
                                    //the box
                                    Container(
                                      height: deviceInfo.deviceType ==
                                              DeviceType.Mobile
                                          ? 100.0
                                          : 150.0,
                                      width: deviceInfo.deviceType ==
                                              DeviceType.Mobile
                                          ? deviceInfo.width * 0.8
                                          : deviceInfo.width * 0.7,
                                      decoration: BoxDecoration(
                                        color: Color(
                                          int.parse(widget.series.color),
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          deviceInfo.deviceType ==
                                                  DeviceType.Mobile
                                              ? 30.0
                                              : 50.0,
                                        ),
                                      ),
                                    ),
                                    //the image beside
                                    Positioned(
                                      right: 0,
                                      child: CachedNetworkImage(
                                        imageUrl: widget.series.image,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: deviceInfo.deviceType ==
                                                  DeviceType.Mobile
                                              ? 100.0
                                              : 150.0,
                                          width: deviceInfo.deviceType ==
                                                  DeviceType.Mobile
                                              ? 120.0
                                              : 150.0,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(
                                                deviceInfo.deviceType ==
                                                        DeviceType.Mobile
                                                    ? 30.0
                                                    : 50.0,
                                              ),
                                              bottomRight: Radius.circular(
                                                deviceInfo.deviceType ==
                                                        DeviceType.Mobile
                                                    ? 30.0
                                                    : 50.0,
                                              ),
                                            ),
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: imageProvider),
                                          ),
                                        ),
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                      ),
                                    ),
                                    //the text on box
                                    Positioned(
                                      right: deviceInfo.deviceType ==
                                              DeviceType.Mobile
                                          ? 140.0
                                          : 180.0,
                                      top: deviceInfo.deviceType ==
                                              DeviceType.Mobile
                                          ? 8.0
                                          : 20.0,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: deviceInfo.width,
                                            child: Text(
                                              widget.series.content[index]
                                                  .episodes[i],
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25.0,
                                                  fontFamily: 'Dubai B'),
                                            ),
                                          ),
                                          Container(
                                            width: deviceInfo.width,
                                            child: Text(
                                              widget.series.content[index].name,
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.0,
                                                  fontFamily: 'Dubai R'),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
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

class HeaderPage extends SliverPersistentHeaderDelegate {
  final double maxE;
  final double minE;
  final Series series;
  final Function onTap;
  HeaderPage({this.maxE, this.minE, this.series, this.onTap});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    return WidgetInfo(builder: (context, deviceInfo) {
      return Stack(
        alignment: Alignment.center,
        children: [
          //image
          CachedNetworkImage(
            imageUrl: series.image,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                image: new DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(titleOpacity(shrinkOffset / 2)),
                    BlendMode.dstATop,
                  ),
                  image: imageProvider,
                ),
              ),
            ),
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
          ),
          //shadow in the bottom
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black54],
                stops: [0.5, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.repeated,
              ),
            ),
          ),
          //Back Button
          CustomBackButton(),
          //Text
          Positioned(
            right: 30.0,
            top: 40.0,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              width: cWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.rtl,
                children: [
                  //Name
                  Text(series.name,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: deviceInfo.deviceType == DeviceType.Mobile
                              ? 40.0
                              : 70.0,
                          color: Colors.white,
                          fontFamily: 'Dubai B')),
                  //Date
                  Text(series.date,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontSize: deviceInfo.deviceType == DeviceType.Mobile
                              ? 20.0
                              : 30.0,
                          color: Colors.white,
                          fontFamily: 'Dubai R')),
                  //Description
                  Text(series.description,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        backgroundColor: Colors.black38,
                        fontSize: deviceInfo.deviceType == DeviceType.Mobile
                            ? 20.0
                            : 35.0,
                        color: Colors.white,
                        fontFamily: 'Dubai R',
                      ))
                ],
              ),
            ),
          ),
          //Icons
          Positioned(
            bottom: 10.0,
            child: Row(
              children: [
                //Share
                CustomIconButton(
                  onTap: () {
                    Share.share('شارك ${series.name} مع أصدقائك');
                  },
                  icon: CustomIcon.share,
                  size:
                      deviceInfo.deviceType == DeviceType.Mobile ? 40.0 : 70.0,
                  color: Colors.white,
                ),
                //Play
                CustomIconButton(
                  onTap: onTap,
                  icon: Icons.play_circle_filled_rounded,
                  size: deviceInfo.deviceType == DeviceType.Mobile
                      ? 150.0
                      : 200.0,
                  color: Colors.white,
                ),
                //Like
                CircularLike(
                  id: series.id,
                  name: series.name,
                  image: series.image,
                  category: 'series',
                ),
              ],
            ),
          )
        ],
      );
    });
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
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
