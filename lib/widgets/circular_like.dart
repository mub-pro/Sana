import 'package:flutter/material.dart';
import 'package:original_sana/database/moor/favorites.dart';
import 'package:original_sana/sizes_information/widget_info.dart';
import 'package:provider/provider.dart';

import '../custom_icon_icons.dart';
import 'custom_icon_button.dart';

class CircularLike extends StatelessWidget {
  final String id;
  final String name;
  final String image;
  final String category;
  final double size;

  CircularLike({
    this.id,
    this.name,
    this.image,
    this.category,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final myDatabase = Provider.of<MyDatabase>(context);
    return WidgetInfo(
      builder: (context, deviceInfo) {
        return StreamBuilder<bool>(
          stream: myDatabase.isFavorite(id),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data) {
              //Liked
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    color: Colors.redAccent,
                    width: size * .65,
                    height: size * .6,
                  ),
                  CustomIconButton(
                    onTap: () {
                      myDatabase.removeFavorite(id);
                    },
                    icon: CustomIcon.heart_circle,
                    size: size,
                    color: Colors.white,
                  ),
                ],
              );
            }
            //Not Liked
            return CustomIconButton(
              onTap: () {
                myDatabase.addFavorite(Favorite(
                    id: id, name: name, image: image, category: category));
              },
              icon: CustomIcon.heart_circle,
              size: size,
              color: Colors.white,
            );
          },
        );
      },
    );
  }
}
