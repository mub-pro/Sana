import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:original_sana/models/models.dart';
import 'package:original_sana/sizes_information/device_type.dart';
import 'package:original_sana/sizes_information/widget_info.dart';
import 'package:original_sana/widgets/circular_like.dart';
import 'package:original_sana/widgets/custom_back_button.dart';
import 'package:original_sana/widgets/custom_icon_button.dart';
import 'package:share/share.dart';

import '../custom_icon_icons.dart';

class StoryScreen extends StatelessWidget {
  final Story story;
  StoryScreen({this.story});
  @override
  Widget build(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      body: SingleChildScrollView(
        child: WidgetInfo(
          builder: (context, deviceInfo) {
            return Column(
              children: [
                // Header
                Container(
                  height: deviceInfo.height * 0.4,
                  color: Color(0xFF5300B4),
                  child: Stack(
                    children: [
                      //Back Button
                      CustomBackButton(),
                      //Text
                      Positioned(
                        right: deviceInfo.deviceType == DeviceType.Mobile
                            ? 20.0
                            : 50.0,
                        top: deviceInfo.deviceType == DeviceType.Mobile
                            ? 60.0
                            : 80.0,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          width: cWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            textDirection: TextDirection.rtl,
                            children: [
                              //Name
                              Text(
                                story.name,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: deviceInfo.deviceType ==
                                            DeviceType.Mobile
                                        ? 40.0
                                        : 70.0,
                                    color: Colors.white,
                                    fontFamily: 'Dubai B'),
                              ),
                              //Date
                              Text(
                                story.date,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: deviceInfo.deviceType ==
                                            DeviceType.Mobile
                                        ? 20.0
                                        : 35.0,
                                    color: Colors.white,
                                    fontFamily: 'Dubai R'),
                              ),
                              //Description
                              Text(story.description,
                                  textDirection: TextDirection.rtl,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: deviceInfo.deviceType ==
                                            DeviceType.Mobile
                                        ? 20.0
                                        : 30.0,
                                    color: Colors.white,
                                    fontFamily: 'Dubai R',
                                    letterSpacing: 3.0,
                                  ))
                            ],
                          ),
                        ),
                      ),
                      //Icons
                      Positioned(
                        bottom: 20.0,
                        left: 20.0,
                        child: Row(
                          children: [
                            //Share
                            CustomIconButton(
                              onTap: () {
                                print('SHARE Story');
                                Share.share('شارك ${story.name} مع أصدقائك');
                              },
                              icon: CustomIcon.share,
                              size: deviceInfo.deviceType == DeviceType.Mobile
                                  ? 40.0
                                  : 70.0,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10.0),
                            //Like
                            CircularLike(
                              id: story.id,
                              name: story.name,
                              image: story.image,
                              category: 'story',
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 40.0),
                //Content
                Container(
                  width: cWidth,
                  child: Column(
                    children: List.generate(
                      story.storyContent.length,
                      (i) => Column(
                        children: [
                          Text(
                            story.storyContent[i].script,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontSize:
                                    deviceInfo.deviceType == DeviceType.Mobile
                                        ? 25.0
                                        : 45.0,
                                fontFamily: 'Dubai R'),
                          ),
                          SizedBox(
                              height: deviceInfo.deviceType == DeviceType.Mobile
                                  ? 20.0
                                  : 40.0),
                          story.storyContent[i].image != null
                              ? Image.network(
                                  story.storyContent[i].image,
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30.0)
              ],
            );
          },
        ),
      ),
    );
  }
}
