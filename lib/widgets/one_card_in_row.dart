import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:original_sana/database/moor/favorites.dart';
import 'package:original_sana/sizes_information/device_type.dart';
import 'package:original_sana/sizes_information/widget_info.dart';
import 'package:provider/provider.dart';

import '../custom_icon_icons.dart';

class OneCardInRow extends StatelessWidget {
  final String id;
  final String name;
  final String image;
  final String category;
  final Function onTap;
  OneCardInRow({this.id, this.name, this.image, this.category, this.onTap});
  @override
  Widget build(BuildContext context) {
    var myDatabase = Provider.of<MyDatabase>(context);
    return WidgetInfo(builder: (context, deviceInfo) {
      return InkWell(
        borderRadius: BorderRadius.circular(15.0),
        onTap: onTap,
        child: Container(
          width: deviceInfo.deviceType == DeviceType.Mobile
              ? (MediaQuery.of(context).size.width / 3) - 5
              : 210.22,
          child: Card(
            elevation: 0.0,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            semanticContainer: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  deviceInfo.deviceType == DeviceType.Mobile ? 18.0 : 30.0),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                //Image
                CachedNetworkImage(
                  imageUrl: image,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,),
                    ),
                  ),
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                ),
                //Shadow
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black.withOpacity(0.65)],
                      stops: [0.5, 1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      tileMode: TileMode.repeated,
                    ),
                  ),
                ),
                //Name
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      name,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: deviceInfo.deviceType == DeviceType.Mobile
                              ? 15.0
                              : 30.0,
                          color: Colors.white,
                          fontFamily: 'Dubai M'),
                    ),
                  ),
                ),
                //Like
                Align(
                  alignment: Alignment.topRight,
                  child: StreamBuilder<bool>(
                    stream: myDatabase.isFavorite(id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data) {
                        //Liked
                        return IconButton(
                            onPressed: () => myDatabase.removeFavorite(id),
                            icon: Icon(CustomIcon.heart, color: Colors.red),
                            iconSize: deviceInfo.deviceType == DeviceType.Mobile
                                ? 22.0
                                : 38.0,
                            padding: EdgeInsets.all(
                                deviceInfo.deviceType == DeviceType.Mobile
                                    ? 10.0
                                    : 20.0));
                      }
                      //Not Liked
                      return IconButton(
                          iconSize: deviceInfo.deviceType == DeviceType.Mobile
                              ? 22.0
                              : 38.0,
                          icon:
                              Icon(CustomIcon.heart_empty, color: Colors.white),
                          onPressed: () => myDatabase.addFavorite(Favorite(
                              id: id,
                              name: name,
                              image: image,
                              category: category)),
                          padding: EdgeInsets.all(
                              deviceInfo.deviceType == DeviceType.Mobile
                                  ? 10.0
                                  : 20.0));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
