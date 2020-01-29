import 'dart:convert';

import 'package:hacker_news/src/models/news_model.dart';
import 'package:hacker_news/src/resources/provider.dart';
import 'package:http/http.dart';

class NewsApiProvider implements Provider {
  Client client = Client();
  final url = "https://hacker-news.firebaseio.com/v0";

  @override
  Future<List<int>> fetchTopIds() async {
    final response = await client.get("$url/topstories.json");
    return json.decode(response.body).cast<int>();
  }

  @override
  Future<NewsModel> fetchItem(int id) async {
    final response = await client.get("$url/item/$id.json");
    final data = json.decode(response.body);
    return NewsModel.fromJson(data);
  }

  @override
  Future<int> insertData(NewsModel model) {
    return null;
  }

  @override
  Future<int> clearCache() {
    // TODO: implement clearCache
    return null;
  }
}
