import 'package:hacker_news/src/models/news_model.dart';
import 'package:hacker_news/src/resources/news_api_provider.dart';
import 'package:hacker_news/src/resources/news_db_provider.dart';
import 'package:hacker_news/src/resources/provider.dart';

class Repository {
  List<Provider> providers = [
    NewsDbProvider(),
    NewsApiProvider(),
  ];

//  CacheProvider cacheProvider = CacheProvider();
//  CacheProvider2 cacheProvider = CacheProvider2();

  Future<List<int>> fetchTopIds() {
     return providers[1].fetchTopIds();
  }

  Future<NewsModel> fetchItem(int id) async {
    Provider provider;
    NewsModel model;

    for (provider in providers) {
      model = await provider.fetchItem(id);
      if (model != null) break;
    }
    for (provider in providers) {
      provider.insertData(model);
    }
    return model;
  }

  clearCache() async {
    for (var provider in providers) {
      await provider.clearCache();
    }
  }
}
