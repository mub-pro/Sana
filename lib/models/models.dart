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

  Series({
    this.id,
    this.name,
    this.content,
    this.image,
    this.description,
    this.date,
    this.color,
  });

  Series.fromJson(Map<String, dynamic> json, String id) {
    this.id = id;
    name = json['name'];
    image = json['image'];
    description = json['description'];
    date = json['date'];
    color = json['color'];
    if (json['content'] != null) {
      content = List<SeriesContent>();
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
  List<StoryContent> storyContent;

  Story({
    this.id,
    this.name,
    this.image,
    this.description,
    this.date,
    this.storyContent,
  });

  Story.fromJson(Map<String, dynamic> json, String id) {
    this.id = id;
    name = json['name'];
    image = json['image'];
    description = json['description'];
    date = json['date'];
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

  Podcast({this.id, this.name, this.image, this.url});

  Podcast.fromJson(Map<String, dynamic> json, String id) {
    this.id = id;
    name = json['name'];
    image = json['image'];
    url = json['url'];
  }
}
