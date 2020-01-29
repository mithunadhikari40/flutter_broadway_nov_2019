import 'package:hacker_news/src/models/news_model.dart';

abstract class Provider {
  Future<List<int>> fetchTopIds();

  Future<NewsModel> fetchItem(int id);

  Future<int> insertData(NewsModel model);

  Future<int> clearCache() ;
}
