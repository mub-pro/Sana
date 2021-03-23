import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:original_sana/database/moor/favorites.dart';
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
          width: deviceInfo.localHeight * .67,
          child: WidgetInfo(builder: (c, d) {
            return Card(
              elevation: 0.0,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              semanticContainer: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(d.localWidth * 0.15),
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
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  //Shadow
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF151c26).withOpacity(0.6),
                          Color(0xFF151c26).withOpacity(0.0),
                        ],
                        stops: [0.0, 0.9],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  //Name
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: deviceInfo.localHeight * 0.06),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        name,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: d.localWidth * .12,
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
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(d.localWidth * 0.2)),
                            child: IconButton(
                              icon: Icon(CustomIcon.heart, color: Colors.red),
                              iconSize: d.localWidth * .15,
                              onPressed: () => myDatabase.removeFavorite(id),
                              padding: EdgeInsets.all(d.localWidth * .1),
                            ),
                          );
                        }
                        //Not Liked
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(d.localWidth * 0.2)),
                          child: IconButton(
                            icon: Icon(CustomIcon.heart_empty,
                                color: Colors.white),
                            iconSize: d.localWidth * .15,
                            onPressed: () => myDatabase.addFavorite(Favorite(
                                id: id,
                                name: name,
                                image: image,
                                category: category)),
                            padding: EdgeInsets.all(d.localWidth * .1),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      );
    });
  }
}
