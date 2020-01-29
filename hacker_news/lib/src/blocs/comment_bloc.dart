import 'dart:async';

import 'package:hacker_news/src/models/news_model.dart';
import 'package:hacker_news/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class CommentBloc {
  final _repository = Repository();
  final _commentFetcher = BehaviorSubject<int>();
  final _commentOutput = BehaviorSubject<Map<int, Future<NewsModel>>>();

  CommentBloc() {
    _commentFetcher.stream
        .transform(_commentTransformer())
        .pipe(_commentOutput);
  }

  //getters for sink

  Function(int) get commentFetcher => _commentFetcher.sink.add;

  //getters for stream

  Observable<Map<int, Future<NewsModel>>> get commentOutput =>
      _commentOutput.stream;

  dispose() {
    _commentFetcher.close();
    _commentOutput.close();
  }

  _commentTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<NewsModel>> cache, int id, int index) {
        cache[id] = _repository.fetchItem(id);
        //recursive data fetching
        _repository.fetchItem(id).then((NewsModel model) {
          model.kids.forEach((kidId) {
            commentFetcher(kidId);
          });
        });

        return cache;
      },
      <int, Future<NewsModel>>{},
    );
  }
}
