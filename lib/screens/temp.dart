import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:original_sana/database/cloud_firestore/data_provider.dart';
import 'package:original_sana/screens/movie_screen.dart';
import 'package:original_sana/screens/series_screen.dart';
import 'package:original_sana/widgets/one_card_in_row.dart';
import 'package:provider/provider.dart';

import 'podcast_screen.dart';
import 'story_screen.dart';

class Temp extends StatefulWidget {
  @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: TextField(
          textDirection: TextDirection.rtl,
          controller: myController,
          onChanged: (value) {
            dataProvider.movieSearch(value);
            dataProvider.seriesSearch(value);
            dataProvider.storySearch(value);
            dataProvider.podcastSearch(value);

            // print(value);
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
                : Consumer<DataProvider>(
                    builder: (context, provider, _) => Column(
                      children: [
                        provider.movieResult.isEmpty
                            ? Container()
                            : GridView.count(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 1,
                                childAspectRatio: 130.0 / 60.0,
                                children: List.generate(
                                  provider.movieResult.length,
                                  (index) {
                                    return OneCardInRow(
                                      id: provider.movieResult[index].id,
                                      name: provider.movieResult[index].name,
                                      image: provider.movieResult[index].image,
                                      category: 'movie',
                                      onTap: () {
                                        dataProvider
                                            .getMovieById(
                                                provider.movieResult[index].id)
                                            .then((value) => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MovieScreen(
                                                            movie: value))));
                                      },
                                    );
                                  },
                                )),
                        provider.seriesResult.isEmpty
                            ? Container()
                            : GridView.count(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 1,
                                childAspectRatio: 130.0 / 60.0,
                                children: List.generate(
                                  provider.seriesResult.length,
                                  (index) {
                                    return OneCardInRow(
                                      id: provider.seriesResult[index].id,
                                      name: provider.seriesResult[index].name,
                                      image: provider.seriesResult[index].image,
                                      category: 'series',
                                      onTap: () {
                                        dataProvider
                                            .getSeriesById(
                                                provider.seriesResult[index].id)
                                            .then((value) => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SeriesScreen(
                                                            series: value))));
                                      },
                                    );
                                  },
                                )),
                        provider.storyResult.isEmpty
                            ? Container()
                            : GridView.count(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 1,
                                childAspectRatio: 130.0 / 60.0,
                                children: List.generate(
                                  provider.storyResult.length,
                                  (index) {
                                    return OneCardInRow(
                                      id: provider.storyResult[index].id,
                                      name: provider.storyResult[index].name,
                                      image: provider.storyResult[index].image,
                                      category: 'story',
                                      onTap: () {
                                        dataProvider
                                            .getStoryById(
                                                provider.storyResult[index].id)
                                            .then((value) => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        StoryScreen(
                                                            story: value))));
                                      },
                                    );
                                  },
                                )),
                        provider.podcastResult.isEmpty
                            ? Container()
                            : GridView.count(
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 1,
                                childAspectRatio: 130.0 / 60.0,
                                children: List.generate(
                                  provider.podcastResult.length,
                                  (index) {
                                    return OneCardInRow(
                                      id: provider.podcastResult[index].id,
                                      name: provider.podcastResult[index].name,
                                      image:
                                          provider.podcastResult[index].image,
                                      category: 'podcast',
                                      onTap: () {
                                        dataProvider
                                            .getPodcastById(provider
                                                .podcastResult[index].id)
                                            .then((value) => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        PodcastScreen(
                                                            podcast: value))));
                                      },
                                    );
                                  },
                                )),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// import 'package:ext_video_player/ext_video_player.dart';
// import 'package:flutter/material.dart';
//
// class Temp extends StatefulWidget {
//   @override
//   _TempState createState() => _TempState();
// }
//
// class _TempState extends State<Temp> {
//   VideoPlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(
//         'https://www.youtube.com/watch?v=VqML5F8hcRQ')
//       ..initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         setState(() {});
//       });
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _controller.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: _controller.value.initialized
//             ? AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               )
//             : Container(),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             _controller.value.isPlaying
//                 ? _controller.pause()
//                 : _controller.play();
//           });
//         },
//         child: Icon(
//           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         ),
//       ),
//     );
//   }
// }
