import 'package:flutter/material.dart';
import 'package:hacker_news/src/blocs/comment_bloc_provider.dart';
import 'package:hacker_news/src/blocs/news_bloc_provider.dart';
import 'package:hacker_news/src/screens/comment_list.dart';
import 'package:hacker_news/src/screens/news_list.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NewsBlocProvider(
      child: CommentBlocProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: true,
//          showSemanticsDebugger: true,
          title: 'Trending News!',
          theme: ThemeData(
            brightness: Brightness.light,
          ),
          onGenerateRoute: _generateRoute,
        ),
      ),
    );
  }

  Route _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (BuildContext context) {
          final bloc = NewsBlocProvider.of(context);
          bloc.fetchTopIds();
          return NewsList();
        });

      case '/Detail':
        var newsIds = settings.arguments as int;
        return MaterialPageRoute(builder: (BuildContext context) {
          final bloc = CommentBlocProvider.of(context);
          bloc.commentFetcher(newsIds);
          return CommentList(newsId: newsIds);
        });

      default:
        return MaterialPageRoute(builder: (BuildContext context) {
          return NewsList();
        });
    }
  }
}
