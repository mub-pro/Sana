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
    return Scaffold(
      body: SingleChildScrollView(
        child: WidgetInfo(
          builder: (context, deviceInfo) {
            return Column(
              children: [
                // Header
                Container(
                  height: deviceInfo.height * .45,
                  color: Color(0xFF5300B4),
                  child: WidgetInfo(
                    builder: (context, headerInfo) {
                      return Stack(
                        children: [
                          //Back Button
                          CustomBackButton(),
                          //Texts
                          Positioned(
                            right: headerInfo.width * .04,
                            top: headerInfo.deviceType == DeviceType.Mobile
                                ? headerInfo.localHeight * .16
                                : headerInfo.localHeight * .13,
                            child: Container(
                              width: deviceInfo.width * .75,
                              padding: const EdgeInsets.all(8.0),
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
                                        fontSize: headerInfo.deviceType ==
                                                DeviceType.Mobile
                                            ? headerInfo.localHeight * .08
                                            : headerInfo.localHeight * .12,
                                        color: Colors.white,
                                        fontFamily: 'Dubai B'),
                                  ),
                                  SizedBox(
                                      height: headerInfo.localHeight * .04),
                                  //Date
                                  Text(
                                    story.date,
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: headerInfo.localHeight * .055,
                                        color: Colors.white,
                                        fontFamily: 'Dubai R'),
                                  ),
                                  SizedBox(
                                      height: headerInfo.localHeight * .04),
                                  //Description
                                  Text(story.description,
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontSize: headerInfo.localHeight * .055,
                                        color: Colors.white,
                                        fontFamily: 'Dubai R',
                                      ))
                                ],
                              ),
                            ),
                          ),
                          //Icons
                          Positioned(
                            bottom: deviceInfo.height * .04,
                            left: deviceInfo.width * .06,
                            child: Row(
                              children: [
                                //Share
                                CustomIconButton(
                                  onTap: () {
                                    Share.share(
                                        'شارك قصة ${story.name} مع أصدقائك');
                                  },
                                  icon: CustomIcon.share,
                                  size: deviceInfo.width * .1,
                                  color: Colors.white,
                                ),
                                SizedBox(width: deviceInfo.width * .02),
                                //Like
                                CircularLike(
                                  id: story.id,
                                  name: story.name,
                                  image: story.image,
                                  category: 'story',
                                  size: deviceInfo.width * .1,
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: deviceInfo.width * .06),
                //Content
                Container(
                  width: deviceInfo.width * 0.8,
                  child: Column(
                    children: List.generate(
                      story.storyContent.length,
                      (i) => Column(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: deviceInfo.width * .06),
                            child: Text(
                              story.storyContent[i].script,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize:
                                      deviceInfo.deviceType == DeviceType.Mobile
                                          ? deviceInfo.width * .06
                                          : deviceInfo.width * .05,
                                  fontFamily: 'Dubai R'),
                            ),
                          ),
                          story.storyContent[i].image != null
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      bottom: deviceInfo.width * .06),
                                  child: Image.network(
                                    story.storyContent[i].image,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
