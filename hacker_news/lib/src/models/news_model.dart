import 'dart:convert';

class NewsModel {
  int id;
  bool deleted;
  String type;
  String by;
  int time;
  String text;
  bool dead;
  int parent;
  List<dynamic> kids;
  String url;
  int score;
  String title;
  int descendants;

  NewsModel.fromJson(Map<String, dynamic> map) {
    id = map["id"];
    deleted = map["deleted"] ?? false;
    type = map["type"];
    by = map["by"] ?? '';
    time = map["time"];
    text = map["text"] ?? '';
    dead = map["dead"] ?? false;
    parent = map["parent"];
    kids = map["kids"] ?? [];
    url = map["url"];
    score = map["score"];
    title = map["title"] ?? '';
    descendants = map["descendants"];
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "deleted": deleted ? 1 : 0,
      "type": type,
      "by": by,
      "time": time,
      "text": text,
      "dead": dead ? 1 : 0,
      "parent": parent,
      "kids": jsonEncode(kids),
      "url": url,
      "score": score,
      "title": title,
      "descendants": descendants
    };
  }

  NewsModel.fromDb(Map<String, dynamic> map) {
    id = map["id"];
    deleted = map["deleted"] == 1;
    type = map["type"];
    by = map["by"];
    time = map["time"];
    text = map["text"];
    dead = map["dead"] == 1;
    parent = map["parent"];
    kids = jsonDecode(map["kids"]);
    url = map["url"];
    score = map["score"];
    title = map["title"];
    descendants = map["descendants"];
  }
}
