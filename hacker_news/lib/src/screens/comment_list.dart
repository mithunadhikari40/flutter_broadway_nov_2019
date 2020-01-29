import 'package:flutter/material.dart';
import 'package:hacker_news/src/blocs/comment_bloc.dart';
import 'package:hacker_news/src/blocs/comment_bloc_provider.dart';
import 'package:hacker_news/src/models/news_model.dart';
import 'package:hacker_news/src/widgets/comment_list_tile.dart';

class CommentList extends StatelessWidget {
  final int newsId;

  CommentList({this.newsId});

  @override
  Widget build(BuildContext context) {
    final bloc = CommentBlocProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentBloc bloc) {
    //create a title
    return StreamBuilder(
      stream: bloc.commentOutput,
      builder: (BuildContext context,
          AsyncSnapshot<Map<int, Future<NewsModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Text("Loading data from stream");
        }
        return buildCommentList(snapshot.data);
      },
    );
  }

  Widget buildCommentList(Map<int, Future<NewsModel>> data) {
    return FutureBuilder(
      future: data[newsId],
      builder: (BuildContext context, AsyncSnapshot<NewsModel> snapshot) {
        if (!snapshot.hasData) {
          return Text("Still loading data from future");
        }

        return buildComment(snapshot.data, data);
      },
    );
  }

  Widget buildComment(NewsModel data, Map<int, Future<NewsModel>> map) {
    final commentList = data.kids.map((kidId) {
      return CommentListTile(
        commentId: kidId,
        map: map,
        depth: 1,
      );
    }).toList();

    return ListView(
      children: <Widget>[
        buildTitle(data),
        ...commentList,

      ],
    );
  }

  Column buildTitle(NewsModel data) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.all(16.0),
          child: Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Divider(
          height: 10,
        ),
      ],
    );
  }
}
