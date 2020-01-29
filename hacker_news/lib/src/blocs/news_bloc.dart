import 'package:hacker_news/src/models/news_model.dart';
import 'package:hacker_news/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class NewsBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();

  final _itemFetcher = BehaviorSubject<int>();

  final _itemsOutput = BehaviorSubject<Map<int, Future<NewsModel>>>();

  NewsBloc() {
    _itemFetcher.stream.transform(_itemTransformer()).pipe(_itemsOutput);
  }

//getters for stream
  Observable<List<int>> get topIdsStream => _topIds.stream;

  Observable<Map<int, Future<NewsModel>>> get itemsOutput =>
      _itemsOutput.stream;

  //getter for sink

  Function(int) get fetchItem => _itemFetcher.sink.add;

   fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  _itemTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<NewsModel>> cache, int id, int index) {
        print("This transformer is ran $index times");
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<NewsModel>>{},
    );
  }


  clearCache(){
    return _repository.clearCache();
  }

  dispose() {
    _topIds.close();
    _itemFetcher.close();
    _itemsOutput.close();
  }
}
