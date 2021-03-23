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
  List<Movie> _movie = [];

  List _movieResult = [];
  List _seriesResult = [];
  List _storyResult = [];
  List _podcastResult = [];

  void movieSearch(String searchKey) {
    if (searchKey.isEmpty) {
      _movieResult = [];
    } else
      _movieResult = _movie.where((e) => e.name.contains(searchKey)).toList();
    notifyListeners();
  }

  void seriesSearch(String searchKey) {
    // print('searching in products');

    if (searchKey.isEmpty) {
      _seriesResult = [];
    } else
      _seriesResult = _series.where((e) => e.name.contains(searchKey)).toList();

    // .where((e) => e.title.toUpperCase().contains(searchKey.toUpperCase()))
    // .toList() as List<Story>;
    // print(_searchResult.length);
    notifyListeners();
  }

  void storySearch(String searchKey) {
    // print('searching in products');

    if (searchKey.isEmpty) {
      _storyResult = [];
    } else
      _storyResult = _story.where((e) => e.name.contains(searchKey)).toList();

    // .where((e) => e.title.toUpperCase().contains(searchKey.toUpperCase()))
    // .toList() as List<Story>;
    // print(_searchResult.length);
    notifyListeners();
  }

  void podcastSearch(String searchKey) {
    // print('searching in products');

    if (searchKey.isEmpty) {
      _podcastResult = [];
    } else
      _podcastResult =
          _podcast.where((e) => e.name.contains(searchKey)).toList();

    // .where((e) => e.title.toUpperCase().contains(searchKey.toUpperCase()))
    // .toList() as List<Story>;
    // print(_searchResult.length);
    notifyListeners();
  }

  List<Movie> get movieResult {
    return _movieResult;
  }

  List<Series> get seriesResult {
    return _seriesResult;
  }

  List<Story> get storyResult {
    return _storyResult;
  }

  List<Podcast> get podcastResult {
    return _podcastResult;
  }

  Future<List<Movie>> fetchMovie() async {
    var result = await _movieApi.getDataCollection();
    _movie =
        result.docs.map((doc) => Movie.fromJson(doc.data(), doc.id)).toList();
    notifyListeners();
    return _movie;
  }

  Future<List<Series>> fetchSeries() async {
    var result = await _seriesApi.getDataCollection();
    _series =
        result.docs.map((doc) => Series.fromJson(doc.data(), doc.id)).toList();
    notifyListeners();
    return _series;
  }

  Future<List<Story>> fetchStory() async {
    var result = await _storyApi.getDataCollection();
    _story =
        result.docs.map((doc) => Story.fromJson(doc.data(), doc.id)).toList();
    notifyListeners();
    return _story;
  }

  Future<List<Podcast>> fetchPodcast() async {
    var result = await _podcastApi.getDataCollection();
    _podcast =
        result.docs.map((doc) => Podcast.fromJson(doc.data(), doc.id)).toList();
    notifyListeners();
    return _podcast;
  }

  Movie getMById(String id) {
    return _movie.singleWhere((element) => element.id == id);
  }

  List<Movie> get movies => _movie;
  List<Series> get series => _series;
  List<Story> get stories => _story;
  List<Podcast> get podcast => _podcast;

  int get movieLength => _movie.length;
  int get seriesLength => _series.length;
  int get storyLength => _story.length;
  int get podcastLength => _podcast.length;

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
