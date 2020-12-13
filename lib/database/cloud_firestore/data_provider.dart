import 'package:flutter/material.dart';
import 'package:original_sana/models/models.dart';

import 'api.dart';

class DataProvider extends ChangeNotifier {
  Api _seriesApi = Api('series');
  Api _storyApi = Api('story');
  Api _podcastApi = Api('podcast');
  Api _movieApi = Api('movie');
  List<Series> _series;
  List<Story> _story;
  List<Podcast> _podcast;
  List<Movie> _movie;

  Future<List<Series>> fetchSeries() async {
    var result = await _seriesApi.getDataCollection();
    _series =
        result.docs.map((doc) => Series.fromJson(doc.data(), doc.id)).toList();
    return _series;
  }

  Future<List<Story>> fetchStory() async {
    var result = await _storyApi.getDataCollection();
    _story =
        result.docs.map((doc) => Story.fromJson(doc.data(), doc.id)).toList();
    return _story;
  }

  Future<List<Podcast>> fetchPodcast() async {
    var result = await _podcastApi.getDataCollection();
    _podcast =
        result.docs.map((doc) => Podcast.fromJson(doc.data(), doc.id)).toList();
    return _podcast;
  }

  Future<List<Movie>> fetchMovie() async {
    var result = await _movieApi.getDataCollection();
    _movie =
        result.docs.map((doc) => Movie.fromJson(doc.data(), doc.id)).toList();
    return _movie;
  }

  Future<Story> getStoryById(String id) async {
    var doc = await _storyApi.getDocumentById(id);
    return Story.fromJson(doc.data(), doc.id);
  }

  Future<Series> getSeriesById(String id) async {
    var doc = await _seriesApi.getDocumentById(id);
    return Series.fromJson(doc.data(), doc.id);
  }

  Future<Movie> getMovieById(String id) async {
    var doc = await _movieApi.getDocumentById(id);
    return Movie.fromJson(doc.data(), doc.id);
  }

  Future<Podcast> getPodcastById(String id) async {
    var doc = await _podcastApi.getDocumentById(id);
    return Podcast.fromJson(doc.data(), doc.id);
  }
}
