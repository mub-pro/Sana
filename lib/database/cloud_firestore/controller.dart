import 'package:flutter/material.dart';
import 'package:original_sana/models/models.dart';

import 'api.dart';

class Controller extends ChangeNotifier {
  Api _seriesApi = Api('series');
  Api _storyApi = Api('story');
  Api _podcastApi = Api('podcast');
  Api _movieApi = Api('movie');
  List<Series> _series;
  List<Story> _story;
  List<Podcast> _podcast;
  List<Movie> _movie;
  List<Search> _search;

  List _searchResult = [];

  Future<List<Search>> fetchSearch() async {
    var m = await _movieApi.getDataCollection();
    var s = await _seriesApi.getDataCollection();
    var st = await _storyApi.getDataCollection();
    var p = await _podcastApi.getDataCollection();

    _search = m.docs
        .map((doc) => Search.fromJson(doc.data(), doc.id, 'movie'))
        .toList();
    _search += s.docs
        .map((doc) => Search.fromJson(doc.data(), doc.id, 'series'))
        .toList();
    _search += st.docs
        .map((doc) => Search.fromJson(doc.data(), doc.id, 'story'))
        .toList();
    _search += p.docs
        .map((doc) => Search.fromJson(doc.data(), doc.id, 'podcast'))
        .toList();
    notifyListeners();
    return _search;
  }

  void searchByKey(String searchKey) {
    if (searchKey.isEmpty) {
      _searchResult = [];
    } else
      _searchResult = _search.where((e) => e.name.contains(searchKey)).toList();
    notifyListeners();
  }

  List<Search> get searchResults {
    return _searchResult;
  }

  Future<List<Movie>> fetchMovie() async {
    var result = await _movieApi.getDataCollection();
    _movie =
        result.docs.map((doc) => Movie.fromJson(doc.data(), doc.id)).toList();
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
    return _podcast;
  }

  List<Movie> get movies => _movie;
  List<Series> get series => _series;
  List<Story> get stories => _story;
  // List<Podcast> get podcast => _podcast;

  int get movieLength => _movie.length;
  int get seriesLength => _series.length;
  int get storyLength => _story.length;
  // int get podcastLength => _podcast.length;

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
