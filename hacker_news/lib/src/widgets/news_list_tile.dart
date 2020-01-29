import 'package:flutter/material.dart';
import 'package:hacker_news/src/blocs/news_bloc_provider.dart';
import 'package:hacker_news/src/models/news_model.dart';
import 'package:hacker_news/src/widgets/loading_container.dart';

class NewsListTile extends StatelessWidget {
  final int id;

  NewsListTile(this.id);

  @override
  Widget build(BuildContext context) {
    final bloc = NewsBlocProvider.of(context);
    return StreamBuilder(
      stream: bloc.itemsOutput,
      builder: (BuildContext context,
          AsyncSnapshot<Map<int, Future<NewsModel>>> snapshot) {
        if (!(snapshot.hasData)) {
          return LoadingContainer();
        }
        return buildNews(snapshot.data[id]);
      },
    );
  }

  Widget buildNews(Future<NewsModel> data) {
    return FutureBuilder(
      future: data,
      builder: (BuildContext context, AsyncSnapshot<NewsModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }
        return buildNewsTile(snapshot.data,context);
      },
    );
  }

  Widget buildNewsTile(NewsModel model, BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(model.title),
          subtitle: Text('${model.score} votes'),
          trailing: Column(
            children: <Widget>[
              Icon(Icons.comment),
              Text('${model.descendants}'),
            ],
          ),
          onTap: (){
            Navigator.of(context).pushNamed('/Detail',arguments: model.id);
          },
        ),
        Divider(
          height: 5.0,
        ),
      ],
    );
  }
}
