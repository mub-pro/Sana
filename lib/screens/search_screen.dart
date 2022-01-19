import 'package:flutter/material.dart';
import 'package:original_sana/database/cloud_firestore/controller.dart';
import 'package:original_sana/models/models.dart';
import 'package:original_sana/widgets/one_card_in_row.dart';
import 'package:provider/provider.dart';

import 'movie_screen.dart';
import 'podcast_screen.dart';
import 'series_screen.dart';
import 'story_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<Controller>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: TextField(
          textDirection: TextDirection.rtl,
          controller: myController,
          onChanged: (value) {
            dataProvider.searchByKey(value);
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 40.0)),
          style: TextStyle(
              fontFamily: 'Dubai M', fontSize: 20.0, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 16),
            myController.text.isEmpty
                ? Text('write something to search!!')
                : Consumer<Controller>(
                    builder: (context, provider, _) => provider
                            .searchResults.isEmpty
                        ? Container(
                            child: Text('لا توجد نتائج'),
                          )
                        : GridView.count(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            addAutomaticKeepAlives: false,
                            addRepaintBoundaries: false,
                            addSemanticIndexes: false,
                            childAspectRatio: 130.0 / 180.0,
                            children: List.generate(
                              provider.searchResults.length,
                              (index) {
                                Search search = provider.searchResults[index];
                                return OneCardInRow(
                                  id: search.id,
                                  name: search.name,
                                  image: search.image,
                                  category: search.category,
                                  onTap: () {
                                    switch (search.category) {
                                      case 'story':
                                        dataProvider
                                            .getStoryById(search.id)
                                            .then((value) => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        StoryScreen(
                                                            story: value))));
                                        break;
                                      case 'podcast':
                                        dataProvider
                                            .getPodcastById(search.id)
                                            .then((value) => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PodcastScreen(
                                                            podcast: value))));
                                        break;
                                      case 'movie':
                                        dataProvider
                                            .getMovieById(search.id)
                                            .then((value) => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MovieScreen(
                                                            movie: value))));
                                        break;
                                      case 'series':
                                        dataProvider
                                            .getSeriesById(search.id)
                                            .then((value) => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SeriesScreen(
                                                            series: value))));
                                        break;
                                    }
                                  },
                                );
                              },
                            )),
                  ),
          ],
        ),
      ),
    );
  }
}
