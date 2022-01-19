class Movie {
  String id;
  String name;
  String image;
  String url;

  Movie({this.id, this.name, this.image, this.url});

  Movie.fromJson(Map<String, dynamic> json, String id) {
    this.id = id;
    name = json['name'];
    image = json['image'];
    url = json['url'];
  }
}

class Series {
  String id;
  String name;
  String image;
  String description;
  String date;
  List<SeriesContent> content;
  String color;
  String header;

  Series(
      {this.id,
      this.name,
      this.content,
      this.image,
      this.description,
      this.date,
      this.color,
      this.header});

  Series.fromJson(Map<String, dynamic> json, String id) {
    this.id = id;
    name = json['name'];
    image = json['image'];
    description = json['description'];
    date = json['date'];
    color = json['color'];
    header = json['header'];
    if (json['content'] != null) {
      content = [];
      json['content'].forEach((v) {
        content.add(SeriesContent.fromJson(v));
      });
    }
  }
}

class SeriesContent {
  String name;
  List<String> episodes;
  List<String> url;

  SeriesContent({this.name, this.episodes, this.url});

  SeriesContent.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    episodes = json['episodes'].cast<String>();
    url = json['URLs'].cast<String>();
  }
}

class Story {
  String id;
  String name;
  String image;
  String description;
  String date;
  String header;
  List<StoryContent> storyContent;

  Story({
    this.id,
    this.name,
    this.image,
    this.description,
    this.date,
    this.storyContent,
    this.header,
  });

  Story.fromJson(Map<String, dynamic> json, String id) {
    this.id = id;
    name = json['name'];
    image = json['image'];
    description = json['description'];
    date = json['date'];
    header = json['header'];
    if (json['content'] != null) {
      storyContent = List<StoryContent>();
      json['content'].forEach((v) {
        storyContent.add(StoryContent.fromJson(v));
      });
    }
  }
}

class StoryContent {
  String script;
  String image;

  StoryContent({this.script, this.image});

  StoryContent.fromJson(Map<String, dynamic> json) {
    script = json['script'];
    image = json['image'];
  }
}

class Podcast {
  String id;
  String name;
  String image;
  String url;
  String header;

  Podcast({this.id, this.name, this.image, this.url, this.header});

  Podcast.fromJson(Map<String, dynamic> json, String id) {
    this.id = id;
    name = json['name'];
    image = json['image'];
    url = json['url'];
    header = json['header'];
  }
}

class Search {
  String id;
  String name;
  String image;
  String category;

  Search({this.id, this.name, this.image, this.category});

  Search.fromJson(Map<String, dynamic> json, String id, String category) {
    this.id = id;
    name = json['name'];
    image = json['image'];
    this.category = category;
  }
}
